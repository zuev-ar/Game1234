import Foundation

/// Длительность раунда Time Attack.
enum TimeAttackDuration: Int, CaseIterable, Hashable, Identifiable {
    case sixty = 60
    case ninety = 90

    var id: Int { rawValue }
    var seconds: Double { Double(rawValue) }
    var title: String { "\(rawValue)s" }
}

/// Игровой режим — полное описание запуска партии.
/// Архитектурный «слот» для добавления будущих режимов (Marathon, Endless, и т.п.).
enum GameMode: Hashable {
    /// Бесконечный режим: ошибка завершает игру, лимит на ответ ужесточается со стриком.
    case survival(Difficulty)
    /// Фиксированное время на партию, ошибка не засчитывается.
    case timeAttack(Difficulty, duration: TimeAttackDuration)

    var difficulty: Difficulty {
        switch self {
        case .survival(let d):         return d
        case .timeAttack(let d, _):    return d
        }
    }

    var kind: Kind {
        switch self {
        case .survival:   return .survival
        case .timeAttack: return .timeAttack
        }
    }

    var title: String { kind.title }

    /// Уникальный идентификатор для ключей рекордов.
    var storageID: String {
        switch self {
        case .survival(let d):
            return "survival.\(d.rawValue)"
        case .timeAttack(let d, let dur):
            return "timeAttack.\(d.rawValue).\(dur.rawValue)"
        }
    }

    /// Подпись результата ("Final Streak" / "Correct Answers").
    var resultCaption: String {
        switch self {
        case .survival:   return "FINAL STREAK"
        case .timeAttack: return "CORRECT ANSWERS"
        }
    }

    /// Короткое описание для главного меню ("Survival · Easy" / "Time Attack 60s · Hard").
    var summary: String {
        switch self {
        case .survival(let d):
            return "Survival · \(d.title)"
        case .timeAttack(let d, let dur):
            return "Time Attack \(dur.title) · \(d.title)"
        }
    }

    enum Kind: String, CaseIterable, Hashable, Identifiable {
        case survival
        case timeAttack

        var id: String { rawValue }

        var title: String {
            switch self {
            case .survival:   return "Survival"
            case .timeAttack: return "Time Attack"
            }
        }

        var subtitle: String {
            switch self {
            case .survival:   return "One mistake — game over"
            case .timeAttack: return "Score as much as you can"
            }
        }
    }
}
