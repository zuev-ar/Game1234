import Foundation

/// ViewModel главного меню. Читает выбранный режим из настроек и рекорд для него.
@MainActor
final class MainMenuViewModel: ObservableObject {

    @Published private(set) var selectedMode: GameMode = .survival(.easy)
    @Published private(set) var bestScore: Int = 0

    private let storage: ScoreStorageProtocol
    private let settings: SettingsStorageProtocol

    init(storage: ScoreStorageProtocol = UserDefaultsScoreStorage(),
         settings: SettingsStorageProtocol = UserDefaultsSettingsStorage()) {
        self.storage = storage
        self.settings = settings
    }

    /// Перечитывает выбор режима и рекорд (вызывать при появлении экрана).
    func refresh() {
        selectedMode = buildSelectedMode()
        bestScore = storage.bestScore(for: selectedMode)
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
