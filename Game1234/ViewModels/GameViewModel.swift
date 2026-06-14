//
//  GameViewModel.swift
//  Game1234
//
//  Created by zuev_ar on 13.06.2026.
//

import Foundation
import Combine

/// ViewModel игрового экрана. Вся игровая логика — здесь, View только отображает состояние.
@MainActor
final class GameViewModel: ObservableObject {

    // MARK: - Tuning

    private enum Config {
        static let startTimeLimit: Double = 5.0
        static let minTimeLimit: Double = 2.0
        static let decrementStep: Double = 0.2
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

    init(generator: ProblemGenerating = ProblemGenerator(),
         storage: ScoreStorageProtocol = UserDefaultsScoreStorage(),
         ticker: GameTicking = GameTicker()) {
        self.generator = generator
        self.storage = storage
        self.ticker = ticker
    }

    // MARK: - Intents

    func startGame() {
        streak = 0
        phase = .playing
        nextRound()
        ticker.start(onTick: { [weak self] in self?.tick() })
    }

    func answerSelected(_ answer: Int) {
        guard phase == .playing, let problem = currentProblem else { return }

        if answer == problem.answer {
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
        currentProblem = generator.nextProblem()
        timeLimit = timeLimitForCurrentStreak()
        timeRemaining = timeLimit
    }

    private func timeLimitForCurrentStreak() -> Double {
        let steps = streak / Config.answersPerDecrement
        let limit = Config.startTimeLimit - Double(steps) * Config.decrementStep
        return max(Config.minTimeLimit, limit)
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
        let isNewRecord = storage.saveStreakIfRecord(streak)
        phase = .gameOver(streak: streak, isNewRecord: isNewRecord, personalBest: storage.bestStreak)
    }
}
