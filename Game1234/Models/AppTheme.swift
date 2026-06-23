// /Models/AppTheme.swift
import SwiftUI

/// Тема оформления приложения, выбираемая пользователем.
enum AppTheme: String, CaseIterable, Identifiable {
    case system
    case light
    case dark

    var id: String { rawValue }

    /// Значение для `preferredColorScheme`. `nil` — следовать системной.
    var colorScheme: ColorScheme? {
        switch self {
        case .system: return nil
        case .light:  return .light
        case .dark:   return .dark
        }
    }

    var title: String {
        switch self {
        case .system: return "System"
        case .light:  return "Light"
        case .dark:   return "Dark"
        }
    }

    /// Ключ UserDefaults — общий для VM и `@AppStorage` на уровне корня.
    static let storageKey = "game1234.settings.appTheme"
}
