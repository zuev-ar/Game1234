import Foundation

/// ViewModel главного меню. Хранит выбранный уровень и его рекорд.
@MainActor
final class MainMenuViewModel: ObservableObject {

    @Published var difficulty: Difficulty = .easy {
        didSet { refresh() }
    }
    @Published private(set) var bestStreak: Int = 0

    private let storage: ScoreStorageProtocol

    init(storage: ScoreStorageProtocol = UserDefaultsScoreStorage()) {
        self.storage = storage
    }

    /// Перечитывает рекорд выбранного уровня (например, при появлении экрана).
    func refresh() {
        bestStreak = storage.bestStreak(for: difficulty)
    }
}
