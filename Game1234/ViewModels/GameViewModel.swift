import Foundation
import Combine

/// ViewModel игрового экрана. Вся игровая логика — здесь, View только отображает состояние.
@MainActor
final class GameViewModel: ObservableObject {

    // MARK: - Tuning

    private enum Config {
        /// На сколько уменьшать лимит за каждый порог правильных ответов.
        static let decrementStep: Double = 0.2
        /// Порог: каждые N правильных ответов лимит уменьшается на decrementStep.
        static let answersPerDecrement: Int = 5
    }

    // MARK: - Published state

    @Published private(set) var phase: GamePhase = .idle
    @Published private(set) var currentProblem: Problem?
    @Published private(set) var streak: Int = 0
    @Published private(set) var timeRemaining: Double = 0
    @Published private(set) var timeLimit: Double = 0

    var timeProgress: Double {
        guard timeLimit > 0 else { return 0 }
        return max(0, min(1, timeRemaining / timeLimit))
    }

    // MARK: - Dependencies

    private let generator: ProblemGenerating
    private let storage: ScoreStorageProtocol
    private let ticker: GameTicking
    private var difficulty: Difficulty = .easy

    init(generator: ProblemGenerating = ProblemGenerator(),
         storage: ScoreStorageProtocol = UserDefaultsScoreStorage(),
         ticker: GameTicking = GameTicker()) {
        self.generator = generator
        self.storage = storage
        self.ticker = ticker
    }

    // MARK: - Intents

    func startGame(difficulty: Difficulty) {
        self.difficulty = difficulty
        streak = 0
        phase = .playing
        nextRound()
        ticker.start(onTick: { [weak self] in self?.tick() })
    }

    /// Выбор варианта по индексу кнопки (0...3).
    func optionSelected(at index: Int) {
        guard phase == .playing, let problem = currentProblem else { return }

        if index == problem.correctIndex {
            streak += 1
            nextRound()
        } else {
            finishGame()
        }
    }

    func stopGame() {
        ticker.stop()
    }

    // MARK: - Private

    private func nextRound() {
        currentProblem = generator.nextProblem(difficulty: difficulty)
        timeLimit = timeLimitForCurrentStreak()
        timeRemaining = timeLimit
    }

    private func timeLimitForCurrentStreak() -> Double {
        let steps = streak / Config.answersPerDecrement
        let limit = difficulty.startTimeLimit - Double(steps) * Config.decrementStep
        return max(difficulty.minTimeLimit, limit)
    }

    private func tick() {
        guard phase == .playing else { return }
        timeRemaining -= ticker.interval
        if timeRemaining <= 0 {
            timeRemaining = 0
            finishGame()
        }
    }

    private func finishGame() {
        ticker.stop()
        let isNewRecord = storage.saveStreakIfRecord(streak, for: difficulty)
        phase = .gameOver(streak: streak, isNewRecord: isNewRecord, personalBest: storage.bestStreak(for: difficulty))
    }
}
