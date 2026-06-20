import Foundation

/// Маршруты навигации приложения.
enum Route: Hashable {
    case game(Difficulty)
    case result(streak: Int, isNewRecord: Bool, personalBest: Int, difficulty: Difficulty)
    case about
    case settings
}
