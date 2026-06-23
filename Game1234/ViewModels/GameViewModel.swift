import Foundation
import Combine

/// ViewModel игрового экрана. Тонкий оркестратор: владеет состоянием и тикером,
/// а логику конкретного режима делегирует `GameRulesEngine` (см. SurvivalEngine, TimeAttackEngine).
@MainActor
final class GameViewModel: ObservableObject {

    // MARK: - Published state

    @Published private(set) var phase: GamePhase = .idle
    @Published private(set) var state: GameState?
    /// Значение обратного отсчёта перед стартом (3 → 2 → 1). nil — отсчёт не идёт.
    @Published private(set) var countdownValue: Int?
    @Published private(set) var isPaused = false

    // MARK: - Derived (для View)

    var currentProblem: Problem? { state?.problem }
    var score: Int { state?.score ?? 0 }
    var timeRemaining: Double { state?.timeRemaining ?? 0 }
    var timeLimit: Double { state?.timeLimit ?? 0 }
    var timeProgress: Double {
        guard let s = state, s.timeLimit > 0 else { return 0 }
        return max(0, min(1, s.timeRemaining / s.timeLimit))
    }

    /// Активный режим (читает View, например, для подписей).
    private(set) var mode: GameMode = .survival(.easy)

    // MARK: - Dependencies

    private let ticker: GameTicking
    private let generator: ProblemGenerating
    private let storage: ScoreStorageProtocol
    private let stats: StatsStorageProtocol
    private let settings: SettingsStorageProtocol

    private var engine: GameRulesEngine?
    private var countdownTask: Task<Void, Never>?

    // Метрики текущей партии.
    private var correctCount: Int = 0
    private var wrongCount: Int = 0
    private var startedAt: Date?

    init(generator: ProblemGenerating = ProblemGenerator(),
         storage: ScoreStorageProtocol = UserDefaultsScoreStorage(),
         stats: StatsStorageProtocol = UserDefaultsStatsStorage(),
         ticker: GameTicking = GameTicker(),
         settings: SettingsStorageProtocol = UserDefaultsSettingsStorage()) {
        self.generator = generator
        self.storage = storage
        self.stats = stats
        self.ticker = ticker
        self.settings = settings
    }

    // MARK: - Intents

    func startGame(mode: GameMode) {
        self.mode = mode
        self.engine = mode.makeEngine(generator: generator)
        state = nil
        phase = .idle
        correctCount = 0
        wrongCount = 0
        startedAt = nil
        if settings.countdownEnabled {
            runCountdown()
        } else {
            beginPlaying()
        }
    }

    /// Выбор варианта по индексу кнопки (0...3).
    func optionSelected(at index: Int) {
        guard phase == .playing,
              let engine,
              let current = state else { return }
        let isCorrect = index == current.problem.correctIndex
        if isCorrect { correctCount += 1 } else { wrongCount += 1 }
        let outcome = isCorrect
            ? engine.applyCorrectAnswer(current)
            : engine.applyWrongAnswer(current)
        process(outcome)
    }

    func pause() {
        guard phase == .playing, !isPaused else { return }
        isPaused = true
        if mode.usesTimer { ticker.stop() }
    }

    func resume() {
        guard phase == .playing, isPaused else { return }
        isPaused = false
        if mode.usesTimer {
            ticker.start(onTick: { [weak self] in self?.tick() })
        }
    }

    func stopGame() {
        countdownTask?.cancel()
        countdownTask = nil
        countdownValue = nil
        isPaused = false
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
        guard let engine else { return }
        state = engine.initialState()
        phase = .playing
        startedAt = Date()
        if mode.usesTimer {
            ticker.start(onTick: { [weak self] in self?.tick() })
        }
    }

    private func tick() {
        guard phase == .playing,
              let engine,
              let current = state else { return }
        process(engine.applyTick(current, interval: ticker.interval))
    }

    private func process(_ outcome: StepOutcome) {
        switch outcome {
        case .running(let newState):
            state = newState
        case .finish(let finalScore):
            finishGame(score: finalScore)
        }
    }

    private func finishGame(score: Int) {
        ticker.stop()
        let isNewRecord = storage.saveScoreIfRecord(score, for: mode)
        let duration = startedAt.map { Date().timeIntervalSince($0) } ?? 0
        let record = GameRecord(mode: mode,
                                score: score,
                                correctAnswers: correctCount,
                                wrongAnswers: wrongCount,
                                duration: max(0, duration))
        stats.append(record)
        phase = .gameOver(score: score,
                          isNewRecord: isNewRecord,
                          personalBest: storage.bestScore(for: mode))
    }
}
