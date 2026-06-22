import Foundation

/// Фазы игрового процесса.
enum GamePhase: Equatable {
    case idle
    case playing
    case gameOver(score: Int, isNewRecord: Bool, personalBest: Int)
}
