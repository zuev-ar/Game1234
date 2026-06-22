import Foundation

/// Survival: бесконечная игра, ошибка завершает партию,
/// раундовый таймер ужесточается со стриком.
@MainActor
final class SurvivalEngine: GameRulesEngine {

    private enum Config {
        /// На сколько уменьшать лимит за каждый порог правильных ответов.
        static let decrementStep: Double = 0.2
        /// Порог: каждые N правильных ответов лимит уменьшается на decrementStep.
        static let answersPerDecrement: Int = 5
    }

    private let difficulty: Difficulty
    private let generator: ProblemGenerating

    init(difficulty: Difficulty, generator: ProblemGenerating) {
        self.difficulty = difficulty
        self.generator = generator
    }

    func initialState() -> GameState {
        let limit = roundTimeLimit(forScore: 0)
        return GameState(score: 0,
                         problem: generator.nextProblem(difficulty: difficulty),
                         timeLimit: limit,
                         timeRemaining: limit)
    }

    func applyCorrectAnswer(_ state: GameState) -> StepOutcome {
        let newScore = state.score + 1
        let limit = roundTimeLimit(forScore: newScore)
        return .running(GameState(score: newScore,
                                  problem: generator.nextProblem(difficulty: difficulty),
                                  timeLimit: limit,
                                  timeRemaining: limit))
    }

    func applyWrongAnswer(_ state: GameState) -> StepOutcome {
        .finish(score: state.score)
    }

    func applyTick(_ state: GameState, interval: Double) -> StepOutcome {
        var s = state
        s.timeRemaining -= interval
        if s.timeRemaining <= 0 {
            return .finish(score: state.score)
        }
        return .running(s)
    }

    private func roundTimeLimit(forScore score: Int) -> Double {
        let steps = score / Config.answersPerDecrement
        let limit = difficulty.startTimeLimit - Double(steps) * Config.decrementStep
        return max(difficulty.minTimeLimit, limit)
    }
}
