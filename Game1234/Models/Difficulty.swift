import Foundation

/// Уровень сложности: набор операций и масштаб операндов.
enum Difficulty: String, CaseIterable, Identifiable, Codable {
    case easy
    case medium
    case hard

    var id: String { rawValue }

    var title: String {
        switch self {
        case .easy:   return "Easy"
        case .medium: return "Medium"
        case .hard:   return "Hard"
        }
    }

    var subtitle: String {
        switch self {
        case .easy:   return "Add & subtract"
        case .medium: return "+ Division"
        case .hard:   return "+ Multiplication"
        }
    }

    /// Доступные операции на уровне.
    var operations: [Operation] {
        switch self {
        case .easy:   return [.addition, .subtraction]
        case .medium: return [.addition, .subtraction, .division]
        case .hard:   return [.addition, .subtraction, .division, .multiplication]
        }
    }

    /// Стартовое время на ответ, сек (растёт со сложностью — Hard требует больше счёта).
    var startTimeLimit: Double {
        switch self {
        case .easy:   return 5.0
        case .medium: return 6.0
        case .hard:   return 7.0
        }
    }

    /// Нижняя граница времени на ответ, сек.
    var minTimeLimit: Double {
        switch self {
        case .easy:   return 2.0
        case .medium: return 2.5
        case .hard:   return 3.0
        }
    }
}
