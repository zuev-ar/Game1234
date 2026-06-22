import Foundation

/// Маршруты навигации приложения.
enum Route: Hashable {
    case game(GameMode)
    case result(score: Int, isNewRecord: Bool, personalBest: Int, mode: GameMode)
    case about
    case settings
}
