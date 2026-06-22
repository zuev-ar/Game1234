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
    /// Значение обратного отсчёта перед стартом (3 → 2 → 1). nil — отсчёт не идёт.
    @Published private(set) var countdownValue: Int?

    var timeProgress: Double {
        guard timeLimit > 0 else { return 0 }
        return max(0, min(1, timeRemaining / timeLimit))
    }

    // MARK: - Dependencies

    private let generator: ProblemGenerating
    private let storage: ScoreStorageProtocol
    private let ticker: GameTicking
    private let settings: SettingsStorageProtocol
    private var difficulty: Difficulty = .easy
    private var countdownTask: Task<Void, Never>?

    init(generator: ProblemGenerating = ProblemGenerator(),
         storage: ScoreStorageProtocol = UserDefaultsScoreStorage(),
         ticker: GameTicking = GameTicker(),
         settings: SettingsStorageProtocol = UserDefaultsSettingsStorage()) {
        self.generator = generator
        self.storage = storage
        self.ticker = ticker
        self.settings = settings
    }

    // MARK: - Intents

    func startGame(difficulty: Difficulty) {
        self.difficulty = difficulty
        streak = 0
        phase = .idle
        if settings.countdownEnabled {
            runCountdown()
        } else {
            beginPlaying()
        }
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
        countdownTask?.cancel()
        countdownTask = nil
        countdownValue = nil
        ticker.stop()
    }

    // MARK: - Private

    private func runCountdown() {
        countdownTask?.cancel()
        countdownTask = Task { [weak self] in
            guard let self else { return }
            for value in [3, 2, 1] {
                self.countdownValue = value
                try? await Task.sleep(nanoseconds: 1_000_000_000)
                if Task.isCancelled { return }
            }
            self.countdownValue = nil
            self.beginPlaying()
        }
    }

    private func beginPlaying() {
        phase = .playing
        nextRound()
        ticker.start(onTick: { [weak self] in self?.tick() })
    }

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
