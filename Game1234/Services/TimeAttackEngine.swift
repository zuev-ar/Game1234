import Foundation

/// Time Attack: фиксированное время партии (60/90с), ошибка не завершает игру и не засчитывается.
/// Цель — максимум правильных ответов за отведённое время.
@MainActor
final class TimeAttackEngine: GameRulesEngine {

    private let difficulty: Difficulty
    private let duration: TimeAttackDuration
    private let generator: ProblemGenerating

    init(difficulty: Difficulty,
         duration: TimeAttackDuration,
         generator: ProblemGenerating) {
        self.difficulty = difficulty
        self.duration = duration
        self.generator = generator
    }

    func initialState() -> GameState {
        GameState(score: 0,
                  problem: generator.nextProblem(difficulty: difficulty),
                  timeLimit: duration.seconds,
                  timeRemaining: duration.seconds)
    }

    func applyCorrectAnswer(_ state: GameState) -> StepOutcome {
        var s = state
        s.score += 1
        s.problem = generator.nextProblem(difficulty: difficulty)
        // Общий таймер партии не сбрасывается на ответ.
        return .running(s)
    }

    func applyWrongAnswer(_ state: GameState) -> StepOutcome {
        var s = state
        // Score не увеличивается; пример меняется, чтобы игрок не залипал.
        s.problem = generator.nextProblem(difficulty: difficulty)
        return .running(s)
    }

    func applyTick(_ state: GameState, interval: Double) -> StepOutcome {
        var s = state
        s.timeRemaining -= interval
        if s.timeRemaining <= 0 {
            return .finish(score: state.score)
        }
        return .running(s)
    }
}
