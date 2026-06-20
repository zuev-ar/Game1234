import Foundation

/// Арифметическая операция.
enum Operation: String, CaseIterable {
    case addition = "+"
    case subtraction = "−"
    case division = "÷"
    case multiplication = "×"

    /// Применяет операцию к операндам.
    func apply(_ lhs: Int, _ rhs: Int) -> Int {
        switch self {
        case .addition:       return lhs + rhs
        case .subtraction:    return lhs - rhs
        case .division:       return lhs / rhs
        case .multiplication: return lhs * rhs
        }
    }
}
