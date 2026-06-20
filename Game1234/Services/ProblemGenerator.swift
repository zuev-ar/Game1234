import Foundation

/// Генерирует примеры с четырьмя вариантами ответа под заданный уровень сложности.
protocol ProblemGenerating {
    func nextProblem(difficulty: Difficulty) -> Problem
}

final class ProblemGenerator: ProblemGenerating {

    /// Максимально допустимый результат и значение варианта.
    private static let maxResult = 100

    private var lastText: String?

    func nextProblem(difficulty: Difficulty) -> Problem {
        var problem = makeProblem(difficulty: difficulty)
        // Не повторяем предыдущее выражение подряд.
        while problem.text == lastText {
            problem = makeProblem(difficulty: difficulty)
        }
        lastText = problem.text
        return problem
    }

    // MARK: - Problem core

    private func makeProblem(difficulty: Difficulty) -> Problem {
        let operation = difficulty.operations.randomElement()!
        let (left, right, answer) = operands(for: operation)

        let distractors = makeDistractors(answer: answer, left: left, right: right, exclude: operation)
        let options = ([answer] + distractors).shuffled()
        let correctIndex = options.firstIndex(of: answer)!

        return Problem(
            leftOperand: left,
            rightOperand: right,
            operation: operation,
            options: options,
            correctIndex: correctIndex
        )
    }

    /// Подбирает корректные операнды для операции (результат 1...maxResult, без отрицательных, деление нацело).
    private func operands(for operation: Operation) -> (left: Int, right: Int, answer: Int) {
        switch operation {
        case .addition:
            let a = Int.random(in: 1...50)
            let b = Int.random(in: 1...min(50, Self.maxResult - a))
            return (a, b, a + b)

        case .subtraction:
            let a = Int.random(in: 2...Self.maxResult)
            let b = Int.random(in: 1...(a - 1))
            return (a, b, a - b)

        case .division:
            // Обратное к таблице умножения: a ÷ b = answer, где b и answer оба 2...9.
            // Делимое a = b × answer ≤ 81, делитель и частное в пределах таблицы.
            let b = Int.random(in: 2...9)
            let answer = Int.random(in: 2...9)
            return (b * answer, b, answer)

        case .multiplication:
            // Таблица умножения: оба множителя 2...9, произведение 4...81.
            let a = Int.random(in: 2...9)
            let b = Int.random(in: 2...9)
            return (a, b, a * b)
        }
    }

    // MARK: - Distractors (схема C: близкий + ошибка-операция + случайный)

    private func makeDistractors(answer: Int, left: Int, right: Int, exclude: Operation) -> [Int] {
        var set: Set<Int> = [answer]
        var result: [Int] = []

        // 1. Близкий: answer ± небольшое смещение.
        if let near = pick(near: answer, excluding: set) {
            set.insert(near); result.append(near)
        }

        // 2. Правдоподобная ошибка: результат другой операции над теми же операндами.
        if let mistake = plausibleMistake(left: left, right: right, exclude: exclude, excluding: set) {
            set.insert(mistake); result.append(mistake)
        }

        // 3. Добиваем до трёх дистракторов. uniqueValue гарантированно возвращает
        //    валидное значение, поэтому холостых итераций и предохранителя не нужно.
        while result.count < 3 {
            let value = uniqueValue(near: answer, excluding: set)
            set.insert(value); result.append(value)
        }
        return result
    }

    /// Уникальное валидное значение рядом с answer. Расширяет окно поиска,
    /// а при исчерпании детерминированно берёт первое свободное число из 1...maxResult.
    /// Возвращает значение всегда (никогда nil): при ≤3 занятых из 100 свободные есть.
    private func uniqueValue(near answer: Int, excluding excluded: Set<Int>) -> Int {
        // Сначала "красивые" близкие значения с расширяющимся окном.
        for spread in stride(from: 4, through: 20, by: 4) {
            if let candidate = pick(near: answer, spread: spread, excluding: excluded) {
                return candidate
            }
        }
        // Гарантированный детерминированный fallback.
        for candidate in 1...Self.maxResult where !excluded.contains(candidate) {
            return candidate
        }
        return answer + 1 // недостижимо: 100 значений, занято ≤3
    }

    /// Близкое значение к answer в пределах ±spread, валидное и не из excluded.
    private func pick(near answer: Int, spread: Int = 3, excluding excluded: Set<Int>) -> Int? {
        for _ in 0..<40 {
            let delta = Int.random(in: -spread...spread)
            let candidate = answer + delta
            if candidate >= 1, candidate <= Self.maxResult, !excluded.contains(candidate) {
                return candidate
            }
        }
        return nil
    }

    /// Результат другой операции над теми же операндами (если он валиден).
    private func plausibleMistake(left: Int, right: Int, exclude: Operation, excluding excluded: Set<Int>) -> Int? {
        let candidates = Operation.allCases
            .filter { $0 != exclude }
            .compactMap { op -> Int? in
                guard op != .division || (right != 0 && left % right == 0) else { return nil }
                let value = op.apply(left, right)
                return (value >= 1 && value <= Self.maxResult) ? value : nil
            }
            .filter { !excluded.contains($0) }
        return candidates.randomElement()
    }
}
