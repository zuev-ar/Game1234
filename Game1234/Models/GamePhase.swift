//
//  GamePhase.swift
//  Game1234
//
//  Created by zuev_ar on 13.06.2026.
//

import Foundation

/// Фазы игрового процесса.
enum GamePhase: Equatable {
    case idle
    case playing
    case gameOver(streak: Int, isNewRecord: Bool, personalBest: Int)
}
