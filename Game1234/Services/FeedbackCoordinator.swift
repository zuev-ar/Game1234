import Foundation

/// Координирует звук и хаптику с учётом пользовательских настроек.
/// View дёргает события игры, не зная про флаги вкл/выкл.
protocol FeedbackProviding {
    func correct()
    func wrong()
    func record()
}

final class FeedbackCoordinator: FeedbackProviding {
    private let sound: SoundPlaying
    private let haptics: HapticFeedbackProviding
    private let settings: SettingsStorageProtocol

    init(sound: SoundPlaying = SoundPlayer(),
         haptics: HapticFeedbackProviding = HapticFeedback(),
         settings: SettingsStorageProtocol = UserDefaultsSettingsStorage()) {
        self.sound = sound
        self.haptics = haptics
        self.settings = settings
    }

    func correct() {
        if settings.soundEnabled { sound.correct() }
        if settings.hapticsEnabled { haptics.success() }
    }

    func wrong() {
        if settings.soundEnabled { sound.wrong() }
        if settings.hapticsEnabled { haptics.error() }
    }

    func record() {
        if settings.soundEnabled { sound.record() }
        if settings.hapticsEnabled { haptics.success() }
    }
}
