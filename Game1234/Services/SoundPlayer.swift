import AudioToolbox

/// Звуковые эффекты игры. Протокол позволяет отключать/подменять в превью и тестах.
protocol SoundPlaying {
    func correct()
    func wrong()
    func record()
}

/// Реализация на системных звуках iOS (без бандла аудиофайлов).
final class SoundPlayer: SoundPlaying {
    // ID системных звуков (см. iphonedevwiki / AudioServices).
    private let correctID: SystemSoundID = 1057  // короткий "tink"
    private let wrongID: SystemSoundID = 1053     // низкий "тук"
    private let recordID: SystemSoundID = 1025    // фанфарный аккорд

    func correct() { AudioServicesPlaySystemSound(correctID) }
    func wrong()   { AudioServicesPlaySystemSound(wrongID) }
    func record()  { AudioServicesPlaySystemSound(recordID) }
}

/// Пустышка для превью, тестов и режима "звук выключен".
final class NoopSoundPlayer: SoundPlaying {
    func correct() {}
    func wrong() {}
    func record() {}
}
