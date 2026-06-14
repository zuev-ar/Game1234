//
//  Route.swift
//  Game1234
//
//  Created by zuev_ar on 13.06.2026.
//

import Foundation

/// Маршруты навигации приложения.
enum Route: Hashable {
    case game
    case result(streak: Int, isNewRecord: Bool, personalBest: Int)
    case about
}
