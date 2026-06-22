import Foundation

/// ViewModel экрана настроек. Тумблеры пишут напрямую в хранилище.
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

    private let settings: SettingsStorageProtocol

    init(settings: SettingsStorageProtocol = UserDefaultsSettingsStorage()) {
        self.settings = settings
        self.soundEnabled = settings.soundEnabled
        self.hapticsEnabled = settings.hapticsEnabled
        self.countdownEnabled = settings.countdownEnabled
    }
}
