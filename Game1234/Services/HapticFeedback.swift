//
//  HapticFeedback.swift
//  Game1234
//
//  Created by zuev_ar on 13.06.2026.
//

import UIKit

/// Тактильная отдача. Протокол позволяет отключать/подменять в превью и тестах.
protocol HapticFeedbackProviding {
    func success()
    func error()
}

final class HapticFeedback: HapticFeedbackProviding {
    func success() {
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }

    func error() {
        UINotificationFeedbackGenerator().notificationOccurred(.error)
    }
}

/// Пустышка для превью и тестов.
final class NoopHapticFeedback: HapticFeedbackProviding {
    func success() {}
    func error() {}
}
