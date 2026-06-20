import Foundation

/// Хранилище игровых результатов (рекорд по уровню сложности).
protocol ScoreStorageProtocol {
    /// Лучший стрик на уровне.
    func bestStreak(for difficulty: Difficulty) -> Int
    /// Сохраняет стрик, если он превышает текущий рекорд уровня.
    /// - Returns: true, если установлен новый рекорд.
    @discardableResult
    func saveStreakIfRecord(_ streak: Int, for difficulty: Difficulty) -> Bool
}

final class UserDefaultsScoreStorage: ScoreStorageProtocol {

    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    private func key(for difficulty: Difficulty) -> String {
        "game1234.bestStreak.\(difficulty.rawValue)"
    }

    func bestStreak(for difficulty: Difficulty) -> Int {
        defaults.integer(forKey: key(for: difficulty))
    }

    @discardableResult
    func saveStreakIfRecord(_ streak: Int, for difficulty: Difficulty) -> Bool {
        guard streak > bestStreak(for: difficulty) else { return false }
        defaults.set(streak, forKey: key(for: difficulty))
        return true
    }
}
