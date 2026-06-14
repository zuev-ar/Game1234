//
//  ProblemGenerator.swift
//  Game1234
//
//  Created by zuev_ar on 13.06.2026.
//

import Foundation

/// Генератор арифметических примеров с ответом в диапазоне 1...4.
protocol ProblemGenerating {
    func nextProblem() -> Problem
}

final class ProblemGenerator: ProblemGenerating {

    /// Допустимые ответы.
    private static let answers = 1...4
    /// Диапазон второго операнда (он же определяет масштаб первого).
    private static let operandRange = 1...20

    private var lastProblem: Problem?

    func nextProblem() -> Problem {
        /// Генерация "от ответа": гарантирует ответ в 1...4 и отсутствие отрицательных значений.
        /// Повтор предыдущего примера исключаем перегенерацией.
        var problem = makeProblem()
        while problem == lastProblem {
            problem = makeProblem()
        }
        lastProblem = problem
        return problem
    }

    // MARK: - Private

    private func makeProblem() -> Problem {
        let answer = Int.random(in: Self.answers)
        let operation = Operation.allCases.randomElement()!

        switch operation {
        case .addition:
            // a + b = answer, где a,b >= 1 → answer >= 2.
            // При answer == 1 разложить на два положительных слагаемых нельзя — берём вычитание.
            guard answer >= 2 else {
                return makeSubtraction(answer: answer)
            }
            let left = Int.random(in: 1...(answer - 1))
            return Problem(leftOperand: left, rightOperand: answer - left, operation: .addition)

        case .subtraction:
            return makeSubtraction(answer: answer)
        }
    }

    /// a - b = answer, где b >= 1, a = answer + b. Оба операнда положительны.
    private func makeSubtraction(answer: Int) -> Problem {
        let right = Int.random(in: Self.operandRange)
        return Problem(leftOperand: answer + right, rightOperand: right, operation: .subtraction)
    }
}
