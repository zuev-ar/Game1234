//
//  ScoreStorage.swift
//  Game1234
//
//  Created by zuev_ar on 13.06.2026.
//

import Foundation

/// Хранилище игровых результатов.
/// Протокол позволяет подменить реализацию (UserDefaults → Supabase/SwiftData) без правок ViewModel.
protocol ScoreStorageProtocol {
    /// Лучший стрик за всё время.
    var bestStreak: Int { get }
    /// Сохраняет стрик, если он превышает текущий рекорд.
    /// - Returns: true, если установлен новый рекорд.
    @discardableResult
    func saveStreakIfRecord(_ streak: Int) -> Bool
}

final class UserDefaultsScoreStorage: ScoreStorageProtocol {

    private enum Keys {
        static let bestStreak = "game1234.bestStreak"
    }

    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    var bestStreak: Int {
        defaults.integer(forKey: Keys.bestStreak)
    }

    @discardableResult
    func saveStreakIfRecord(_ streak: Int) -> Bool {
        guard streak > bestStreak else { return false }
        defaults.set(streak, forKey: Keys.bestStreak)
        return true
    }
}
