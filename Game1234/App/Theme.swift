import SwiftUI

/// Дизайн-токены проекта.
/// Цвета адаптивные: автоматически переключаются light/dark.
enum Theme {

    // MARK: - Colors

    /// Акцент — оранжевый.
    static let accent = Color(hex: 0xFF6B3D)

    /// Фон экрана.
    static let background = adaptive(light: 0xFBF7F4, dark: 0x161311)
    /// Поверхность (карточки, кнопки ответа).
    static let surface = adaptive(light: 0xFFFFFF, dark: 0x221D1A)

    /// Основной текст.
    static let textPrimary = adaptive(light: 0x1A1715, dark: 0xF7F3F0)

    /// Цвет крупных цифр (пример, число результата, цифры на кнопках) — мягкий тёмно-фиолетовый.
    static let numerals = adaptive(light: 0x2E2440, dark: 0xE8E2F0)
    /// Вторичный текст (подписи, рекорд, стрик).
    static let textSecondary = adaptive(light: 0x8A817B, dark: 0x9B928B)

    /// Тонкая обводка (hairline) — полупрозрачная, как в макете.
    static let hairline = adaptiveColor(
        light: Color(white: 0, opacity: 0.07),
        dark: Color(white: 1, opacity: 0.10)
    )
    /// Подложка таймер-трека.
    static let track = adaptiveColor(
        light: Color(white: 0, opacity: 0.08),
        dark: Color(white: 1, opacity: 0.13)
    )

    /// Жёлтый трофея и рекорд-пилюли.
    static let trophy = Color(hex: 0xF5B544)

    // MARK: - Timer gradient

    static let timerGreen = Color(hex: 0x16C172)
    static let timerYellow = Color(hex: 0xFFC53D)
    static let timerRed = Color(hex: 0xFF453A)

    // MARK: - Feedback

    static let correct = Color(hex: 0x16C172)
    static let wrong = Color(hex: 0xFF453A)

    // MARK: - Radii

    enum Radius {
        static let button: CGFloat = 22
        static let answer: CGFloat = 22
        static let chip: CGFloat = 14
        static let resultButton: CGFloat = 20
    }

    // MARK: - Helpers

    /// Дисплейный шрифт. Fallback на системный rounded,
    /// если ttf не добавлен в проект.
    static func display(_ size: CGFloat, weight: Font.Weight = .semibold) -> Font {
        if UIFont(name: "Fredoka-\(fredokaName(weight))", size: size) != nil {
            return .custom("Fredoka-\(fredokaName(weight))", size: size)
        }
        return .system(size: size, weight: weight, design: .rounded)
    }

    private static func fredokaName(_ weight: Font.Weight) -> String {
        switch weight {
        case .bold, .heavy, .black: return "Bold"
        case .semibold:             return "SemiBold"
        case .medium:               return "Medium"
        default:                    return "Regular"
        }
    }

    private static func adaptive(light: UInt, dark: UInt) -> Color {
        adaptiveColor(light: Color(hex: light), dark: Color(hex: dark))
    }

    private static func adaptiveColor(light: Color, dark: Color) -> Color {
        Color(UIColor { traits in
            traits.userInterfaceStyle == .dark ? UIColor(dark) : UIColor(light)
        })
    }
}

extension Color {
    /// Инициализация из 0xRRGGBB.
    init(hex: UInt, alpha: Double = 1.0) {
        self.init(
            .sRGB,
            red:   Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue:  Double(hex & 0xFF) / 255,
            opacity: alpha
        )
    }
}
