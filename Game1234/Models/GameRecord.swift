// /Models/GameRecord.swift
import Foundation

/// Запись о завершённой партии для статистики.
struct GameRecord: Codable, Identifiable, Hashable {
    let id: UUID
    let date: Date
    let modeKind: GameMode.Kind
    let difficulty: Difficulty
    /// Длительность Time Attack, сек (nil для Survival/Practice).
    let timeAttackDuration: Int?
    let score: Int
    let correctAnswers: Int
    let wrongAnswers: Int
    /// Фактическая длительность партии, сек.
    let duration: Double

    init(id: UUID = UUID(),
         date: Date = Date(),
         mode: GameMode,
         score: Int,
         correctAnswers: Int,
         wrongAnswers: Int,
         duration: Double) {
        self.id = id
        self.date = date
        self.modeKind = mode.kind
        self.difficulty = mode.difficulty
        if case .timeAttack(_, let dur) = mode {
            self.timeAttackDuration = dur.rawValue
        } else {
            self.timeAttackDuration = nil
        }
        self.score = score
        self.correctAnswers = correctAnswers
        self.wrongAnswers = wrongAnswers
        self.duration = duration
    }

    /// % точности (0...100). Если ответов не было — 0.
    var accuracy: Double {
        let total = correctAnswers + wrongAnswers
        guard total > 0 else { return 0 }
        return Double(correctAnswers) / Double(total) * 100.0
    }

    /// Краткое описание режима для строки истории.
    var modeSummary: String {
        switch modeKind {
        case .survival:   return "Survival · \(difficulty.title)"
        case .practice:   return "Practice · \(difficulty.title)"
        case .timeAttack:
            let dur = timeAttackDuration.map { "\($0)s" } ?? ""
            return "Time Attack \(dur) · \(difficulty.title)"
        }
    }
}
