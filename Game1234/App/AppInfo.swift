//
//  AppInfo.swift
//  Game1234
//
//  Created by zuev_ar on 14.06.2026.
//

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

    static let tagline = "Tap the answer. Beat the clock."
    static let about = "Solve quick addition and subtraction problems where the answer is always 1, 2, 3 or 4. Race the timer, build your streak, and beat your personal best."

    static var copyright: String {
        let year = Calendar.current.component(.year, from: Date())
        return "© \(year) \(author)"
    }
}
