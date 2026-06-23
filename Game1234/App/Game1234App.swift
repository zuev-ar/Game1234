import SwiftUI

@main
struct Game1234App: App {
    @AppStorage(AppTheme.storageKey) private var themeRaw: String = AppTheme.system.rawValue

    private var appTheme: AppTheme {
        AppTheme(rawValue: themeRaw) ?? .system
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .tint(Theme.accent)
                .preferredColorScheme(appTheme.colorScheme)
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
                    case .game(let mode):
                        GameView(path: $path, mode: mode)
                    case .result(let score, let isNewRecord, let personalBest, let mode):
                        ResultView(path: $path, score: score, isNewRecord: isNewRecord, personalBest: personalBest, mode: mode)
                    case .about:
                        AboutView()
                    case .stats:
                        StatsView()
                    case .settings:
                        SettingsView(path: $path)
                    }
                }
        }
    }
}
