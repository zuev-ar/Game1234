import Foundation

/// ViewModel главного меню. Читает выбранный режим из настроек и рекорд для него.
@MainActor
final class MainMenuViewModel: ObservableObject {

    @Published private(set) var selectedMode: GameMode = .survival(.easy)
    @Published private(set) var bestScore: Int = 0
    /// Сумма решённых примеров в Practice по выбранной сложности (для pill).
    @Published private(set) var practiceSolvedTotal: Int = 0

    private let storage: ScoreStorageProtocol
    private let stats: StatsStorageProtocol
    private let settings: SettingsStorageProtocol

    init(storage: ScoreStorageProtocol = UserDefaultsScoreStorage(),
         stats: StatsStorageProtocol = UserDefaultsStatsStorage(),
         settings: SettingsStorageProtocol = UserDefaultsSettingsStorage()) {
        self.storage = storage
        self.stats = stats
        self.settings = settings
    }

    /// Перечитывает выбор режима, рекорд и накопленную статистику Practice.
    func refresh() {
        selectedMode = buildSelectedMode()
        bestScore = storage.bestScore(for: selectedMode)
        if case .practice(let d) = selectedMode {
            practiceSolvedTotal = stats.allRecords()
                .filter { $0.modeKind == .practice && $0.difficulty == d }
                .reduce(0) { $0 + $1.score }
        } else {
            practiceSolvedTotal = 0
        }
    }

    private func buildSelectedMode() -> GameMode {
        switch settings.modeKind {
        case .survival:
            return .survival(settings.difficulty)
        case .timeAttack:
            return .timeAttack(settings.difficulty, duration: settings.timeAttackDuration)
        case .practice:
            return .practice(settings.difficulty)
        }
    }
}
