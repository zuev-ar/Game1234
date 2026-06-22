// /Services/PracticeEngine.swift
import Foundation

/// Practice: режим для разминки и детей. Без таймера, без проигрыша.
/// Счётчик считает только верные ответы; ошибка лишь обновляет пример.
@MainActor
final class PracticeEngine: GameRulesEngine {

    private let difficulty: Difficulty
    private let generator: ProblemGenerating

    init(difficulty: Difficulty, generator: ProblemGenerating) {
        self.difficulty = difficulty
        self.generator = generator
    }

    func initialState() -> GameState {
        GameState(score: 0,
                  problem: generator.nextProblem(difficulty: difficulty),
                  timeLimit: 0,
                  timeRemaining: 0)
    }

    func applyCorrectAnswer(_ state: GameState) -> StepOutcome {
        var s = state
        s.score += 1
        s.problem = generator.nextProblem(difficulty: difficulty)
        return .running(s)
    }

    func applyWrongAnswer(_ state: GameState) -> StepOutcome {
        var s = state
        s.problem = generator.nextProblem(difficulty: difficulty)
        return .running(s)
    }

    /// В Practice тикер не запускается, но протокол требует реализацию.
    func applyTick(_ state: GameState, interval: Double) -> StepOutcome {
        .running(state)
    }
}
