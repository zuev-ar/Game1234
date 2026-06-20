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

    private let settings: SettingsStorageProtocol

    init(settings: SettingsStorageProtocol = UserDefaultsSettingsStorage()) {
        self.settings = settings
        self.soundEnabled = settings.soundEnabled
        self.hapticsEnabled = settings.hapticsEnabled
    }
}
