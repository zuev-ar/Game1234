import Foundation

/// ViewModel экрана настроек. Тумблеры и пикеры пишут напрямую в хранилище.
@MainActor
final class SettingsViewModel: ObservableObject {

    @Published var soundEnabled: Bool {
        didSet { settings.soundEnabled = soundEnabled }
    }
    @Published var hapticsEnabled: Bool {
        didSet { settings.hapticsEnabled = hapticsEnabled }
    }
    @Published var countdownEnabled: Bool {
        didSet { settings.countdownEnabled = countdownEnabled }
    }

    @Published var modeKind: GameMode.Kind {
        didSet { settings.modeKind = modeKind }
    }
    @Published var difficulty: Difficulty {
        didSet { settings.difficulty = difficulty }
    }
    @Published var timeAttackDuration: TimeAttackDuration {
        didSet { settings.timeAttackDuration = timeAttackDuration }
    }
    @Published var appTheme: AppTheme {
        didSet { settings.appTheme = appTheme }
    }

    private let settings: SettingsStorageProtocol

    init(settings: SettingsStorageProtocol = UserDefaultsSettingsStorage()) {
        self.settings = settings
        self.soundEnabled = settings.soundEnabled
        self.hapticsEnabled = settings.hapticsEnabled
        self.countdownEnabled = settings.countdownEnabled
        self.modeKind = settings.modeKind
        self.difficulty = settings.difficulty
        self.timeAttackDuration = settings.timeAttackDuration
        self.appTheme = settings.appTheme
    }
}
