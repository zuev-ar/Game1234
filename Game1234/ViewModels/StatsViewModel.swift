// /ViewModels/StatsViewModel.swift
import Foundation

/// Фильтр по режиму в экране статистики.
enum StatsFilter: Hashable, Identifiable, CaseIterable {
    case all
    case survival
    case timeAttack
    case practice

    var id: Self { self }

    var title: String {
        switch self {
        case .all:        return "All"
        case .survival:   return "Survival"
        case .timeAttack: return "Time Attack"
        case .practice:   return "Practice"
        }
    }

    func matches(_ record: GameRecord) -> Bool {
        switch self {
        case .all:        return true
        case .survival:   return record.modeKind == .survival
        case .timeAttack: return record.modeKind == .timeAttack
        case .practice:   return record.modeKind == .practice
        }
    }
}

/// Точка для bar chart активности по дням.
struct DayBucket: Identifiable, Hashable {
    let id: Date     // полночь дня
    let day: Date
    let games: Int
}

@MainActor
final class StatsViewModel: ObservableObject {

    @Published var filter: StatsFilter = .all { didSet { recompute() } }
    @Published private(set) var records: [GameRecord] = []
    @Published private(set) var filtered: [GameRecord] = []

    private let stats: StatsStorageProtocol

    init(stats: StatsStorageProtocol = UserDefaultsStatsStorage()) {
        self.stats = stats
    }

    func refresh() {
        records = stats.allRecords()
        recompute()
    }

    private func recompute() {
        filtered = records.filter { filter.matches($0) }
    }

    // MARK: - Aggregations

    var totalGames: Int { filtered.count }

    var bestScore: Int { filtered.map(\.score).max() ?? 0 }

    var bestThisWeek: Int {
        let cutoff = Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()
        return filtered.filter { $0.date >= cutoff }.map(\.score).max() ?? 0
    }

    var averageScore: Double {
        guard !filtered.isEmpty else { return 0 }
        let sum = filtered.reduce(0) { $0 + $1.score }
        return Double(sum) / Double(filtered.count)
    }

    /// Средняя точность (0...100).
    var averageAccuracy: Double {
        let withAnswers = filtered.filter { $0.correctAnswers + $0.wrongAnswers > 0 }
        guard !withAnswers.isEmpty else { return 0 }
        let totalCorrect = withAnswers.reduce(0) { $0 + $1.correctAnswers }
        let totalAnswers = withAnswers.reduce(0) { $0 + $1.correctAnswers + $1.wrongAnswers }
        return Double(totalCorrect) / Double(totalAnswers) * 100.0
    }

    /// Суммарное время игры, сек.
    var totalDuration: Double {
        filtered.reduce(0) { $0 + $1.duration }
    }

    /// 7 столбиков (старые → новые), за последние 7 дней включая сегодня.
    var weeklyBuckets: [DayBucket] {
        let cal = Calendar.current
        let today = cal.startOfDay(for: Date())
        guard let weekAgo = cal.date(byAdding: .day, value: -6, to: today) else { return [] }
        var byDay: [Date: Int] = [:]
        for r in filtered where r.date >= weekAgo {
            let day = cal.startOfDay(for: r.date)
            byDay[day, default: 0] += 1
        }
        return (0..<7).compactMap { offset in
            guard let day = cal.date(byAdding: .day, value: offset, to: weekAgo) else { return nil }
            return DayBucket(id: day, day: day, games: byDay[day] ?? 0)
        }
    }

    /// Последние записи для списка истории.
    var history: [GameRecord] { filtered }

    // MARK: - Format helpers

    func formattedDuration(_ seconds: Double) -> String {
        let total = Int(seconds.rounded())
        let h = total / 3600
        let m = (total % 3600) / 60
        let s = total % 60
        if h > 0 { return String(format: "%dh %02dm", h, m) }
        if m > 0 { return String(format: "%dm %02ds", m, s) }
        return "\(s)s"
    }
}
