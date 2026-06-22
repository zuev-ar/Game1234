import Foundation

/// Пользовательские настройки приложения.
protocol SettingsStorageProtocol: AnyObject {
    var soundEnabled: Bool { get set }
    var hapticsEnabled: Bool { get set }
    var countdownEnabled: Bool { get set }
}

final class UserDefaultsSettingsStorage: SettingsStorageProtocol {

    private enum Keys {
        static let sound = "game1234.settings.sound"
        static let haptics = "game1234.settings.haptics"
        static let countdown = "game1234.settings.countdown"
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
        if defaults.object(forKey: Keys.countdown) == nil {
            defaults.set(true, forKey: Keys.countdown)
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

    var countdownEnabled: Bool {
        get { defaults.bool(forKey: Keys.countdown) }
        set { defaults.set(newValue, forKey: Keys.countdown) }
    }
}
