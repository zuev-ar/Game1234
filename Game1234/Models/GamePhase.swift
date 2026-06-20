import Foundation

/// Фазы игрового процесса.
enum GamePhase: Equatable {
    case idle
    case playing
    case gameOver(streak: Int, isNewRecord: Bool, personalBest: Int)
}
