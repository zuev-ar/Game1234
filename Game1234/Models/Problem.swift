//
//  Problem.swift
//  Game1234
//
//  Created by zuev_ar on 13.06.2026.
//

import Foundation

/// Арифметическая операция в примере.
enum Operation: String, CaseIterable {
    case addition = "+"
    case subtraction = "-"

    /// Применяет операцию к операндам.
    func apply(_ lhs: Int, _ rhs: Int) -> Int {
        switch self {
        case .addition:    return lhs + rhs
        case .subtraction: return lhs - rhs
        }
    }
}

/// Арифметический пример с ответом из множества {1, 2, 3, 4}.
struct Problem: Equatable {
    let leftOperand: Int
    let rightOperand: Int
    let operation: Operation

    /// Правильный ответ (1...4). Вычисляется из операндов — не может разойтись с текстом.
    var answer: Int {
        operation.apply(leftOperand, rightOperand)
    }

    /// Текст выражения, например "7 - 4".
    var text: String {
        "\(leftOperand) \(operation.rawValue) \(rightOperand)"
    }
}
