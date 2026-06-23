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
    static let contactEmail = "info@1234.com"
    static let privacyURL = "https://1234.com/privacy"

    static let tagline = "Four options. One is right.\nBeat the clock."
    static let about = "Pick the correct answer out of four — fast.\nThree modes to choose from: Practice for a calm warm-up with no timer, Time Attack to score as many as you can in 60 or 90 seconds, and Survival where one wrong tap ends the run and the timer keeps shrinking with your streak. Three difficulty tiers add division and multiplication as you level up.\nTrack your progress with weekly charts, best scores, accuracy and total play time."

    static var copyright: String {
        let year = Calendar.current.component(.year, from: Date())
        return "© \(year) \(author)"
    }
}
