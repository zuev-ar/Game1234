import Foundation

/// Пользовательские настройки приложения.
protocol SettingsStorageProtocol: AnyObject {
    var soundEnabled: Bool { get set }
    var hapticsEnabled: Bool { get set }
}

final class UserDefaultsSettingsStorage: SettingsStorageProtocol {

    private enum Keys {
        static let sound = "game1234.settings.sound"
        static let haptics = "game1234.settings.haptics"
    }

    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        // По умолчанию включены, если значение ещё не задано.
        if defaults.object(forKey: Keys.sound) == nil {
            defaults.set(true, forKey: Keys.sound)
        }
        if defaults.object(forKey: Keys.haptics) == nil {
            defaults.set(true, forKey: Keys.haptics)
        }
    }

    var soundEnabled: Bool {
        get { defaults.bool(forKey: Keys.sound) }
        set { defaults.set(newValue, forKey: Keys.sound) }
    }

    var hapticsEnabled: Bool {
        get { defaults.bool(forKey: Keys.haptics) }
        set { defaults.set(newValue, forKey: Keys.haptics) }
    }
}
