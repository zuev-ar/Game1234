import Foundation

/// Хранилище игровых результатов (рекорд по режиму).
protocol ScoreStorageProtocol {
    /// Лучший результат для режима.
    func bestScore(for mode: GameMode) -> Int
    /// Сохраняет результат, если он превышает текущий рекорд режима.
    /// - Returns: true, если установлен новый рекорд.
    @discardableResult
    func saveScoreIfRecord(_ score: Int, for mode: GameMode) -> Bool
}

final class UserDefaultsScoreStorage: ScoreStorageProtocol {

    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    private func key(for mode: GameMode) -> String {
        switch mode {
        case .survival(let d):
            // Сохраняем совместимость со старыми рекордами Survival.
            return "game1234.bestStreak.\(d.rawValue)"
        case .timeAttack, .practice:
            return "game1234.bestScore.\(mode.storageID)"
        }
    }

    func bestScore(for mode: GameMode) -> Int {
        defaults.integer(forKey: key(for: mode))
    }

    @discardableResult
    func saveScoreIfRecord(_ score: Int, for mode: GameMode) -> Bool {
        guard score > bestScore(for: mode) else { return false }
        defaults.set(score, forKey: key(for: mode))
        return true
    }
}
