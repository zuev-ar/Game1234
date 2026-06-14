//
//  GameTicker.swift
//  Game1234
//
//  Created by zuev_ar on 13.06.2026.
//

import Foundation
import Combine

/// Источник периодических тиков для игрового таймера.
/// Абстракция нужна, чтобы в тестах прогонять время синхронно, без RunLoop.
protocol GameTicking {
    /// Интервал одного тика, сек.
    var interval: Double { get }
    /// Запускает тики; closure вызывается на каждом интервале.
    func start(onTick: @escaping () -> Void)
    func stop()
}

/// Боевая реализация на Timer.publish.
final class GameTicker: GameTicking {

    let interval: Double
    private var cancellable: AnyCancellable?

    init(interval: Double = 0.05) {
        self.interval = interval
    }

    func start(onTick: @escaping () -> Void) {
        stop()
        cancellable = Timer.publish(every: interval, on: .main, in: .common)
            .autoconnect()
            .sink { _ in onTick() }
    }

    func stop() {
        cancellable?.cancel()
        cancellable = nil
    }
}
