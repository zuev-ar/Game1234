import Foundation

/// Метаданные приложения. Версия и build читаются из бандла,
/// поэтому всегда совпадают с настройками таргета.
enum AppInfo {
    static let name = "1·2·3·4"

    static var version: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "—"
    }

    static var build: String {
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "—"
    }

    // MARK: - Плейсхолдеры

    static let author = "Zuev A."
    static let contactEmail = "arkady.zuev@gmail.com"
    static let privacyURL = "https://example.com/privacy"

    static let tagline = "Four options. One is right.\nBeat the clock."
    static let about = "Pick the correct answer out of four options as fast as you can. Race the timer, build your streak, and beat your personal best. Three difficulty levels add division and multiplication as you progress."

    static var copyright: String {
        let year = Calendar.current.component(.year, from: Date())
        return "© \(year) \(author)"
    }
}
