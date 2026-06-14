//
//  Game1234App.swift
//  Game1234
//
//  Created by zuev_ar on 12.06.2026.
//

import SwiftUI

@main
struct Game1234App: App {
    var body: some Scene {
        WindowGroup {
            RootView()
                .tint(Theme.accent)
        }
    }
}

/// Корневой контейнер навигации.
struct RootView: View {
    @State private var path: [Route] = []

    var body: some View {
        NavigationStack(path: $path) {
            MainMenuView(path: $path)
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case .game:
                        GameView(path: $path)
                    case .result(let streak, let isNewRecord, let personalBest):
                        ResultView(path: $path, streak: streak, isNewRecord: isNewRecord, personalBest: personalBest)
                    case .about:
                        AboutView()
                    }
                }
        }
    }
}
