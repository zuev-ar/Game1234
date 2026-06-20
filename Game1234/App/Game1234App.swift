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
                    case .game(let difficulty):
                        GameView(path: $path, difficulty: difficulty)
                    case .result(let streak, let isNewRecord, let personalBest, let difficulty):
                        ResultView(path: $path, streak: streak, isNewRecord: isNewRecord, personalBest: personalBest, difficulty: difficulty)
                    case .about:
                        AboutView()
                    case .settings:
                        SettingsView()
                    }
                }
        }
    }
}
