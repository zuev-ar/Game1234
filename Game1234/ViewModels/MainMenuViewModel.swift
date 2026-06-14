//
//  MainMenuViewModel.swift
//  Game1234
//
//  Created by zuev_ar on 13.06.2026.
//

import Foundation

/// ViewModel главного меню. Держит актуальный рекорд, обновляемый при возврате с игры.
@MainActor
final class MainMenuViewModel: ObservableObject {

    @Published private(set) var bestStreak: Int = 0

    private let storage: ScoreStorageProtocol

    init(storage: ScoreStorageProtocol = UserDefaultsScoreStorage()) {
        self.storage = storage
    }

    /// Перечитывает рекорд (например, при появлении экрана).
    func refresh() {
        bestStreak = storage.bestStreak
    }
}
