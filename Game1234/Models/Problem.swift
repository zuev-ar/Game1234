import Foundation

/// Пример с четырьмя вариантами ответа, один из которых верный.
struct Problem: Equatable {
    let leftOperand: Int
    let rightOperand: Int
    let operation: Operation

    /// Четыре варианта ответа в порядке отображения на кнопках.
    let options: [Int]

    /// Индекс верного варианта в options (0...3).
    let correctIndex: Int

    /// Текст выражения, например "8 ÷ 2".
    var text: String {
        "\(leftOperand) \(operation.rawValue) \(rightOperand)"
    }

    /// Верный ответ (значение).
    var answer: Int {
        operation.apply(leftOperand, rightOperand)
    }
}
