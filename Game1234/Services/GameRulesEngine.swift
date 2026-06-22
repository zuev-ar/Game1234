import Foundation

/// Снимок состояния игры, передаваемый между VM и движком правил.
/// Движок чистый: получает состояние, возвращает новое — без скрытой mutable-памяти.
struct GameState: Equatable {
    var score: Int
    var problem: Problem
    /// Полная вместимость таймера (для прогрессбара).
    var timeLimit: Double
    /// Оставшееся время. В Survival — раундовое, в Time Attack — общее.
    var timeRemaining: Double
}

/// Результат шага движка (ответ, тик).
enum StepOutcome: Equatable {
    case running(GameState)
    case finish(score: Int)
}

/// Правила конкретного игрового режима.
/// Расширение под новый режим = новый класс, реализующий этот протокол + ветка в `GameMode.makeEngine`.
@MainActor
protocol GameRulesEngine: AnyObject {
    /// Стартовое состояние (первый пример, начальные значения таймера).
    func initialState() -> GameState
    /// Реакция на правильный ответ.
    func applyCorrectAnswer(_ state: GameState) -> StepOutcome
    /// Реакция на неверный ответ.
    func applyWrongAnswer(_ state: GameState) -> StepOutcome
    /// Реакция на тик таймера.
    func applyTick(_ state: GameState, interval: Double) -> StepOutcome
}

extension GameMode {
    /// Фабрика движка правил по режиму.
    @MainActor
    func makeEngine(generator: ProblemGenerating) -> GameRulesEngine {
        switch self {
        case .survival(let difficulty):
            return SurvivalEngine(difficulty: difficulty, generator: generator)
        case .timeAttack(let difficulty, let duration):
            return TimeAttackEngine(difficulty: difficulty, duration: duration, generator: generator)
        }
    }
}
