import SwiftUI

struct MainMenuView: View {
    @Binding var path: [Route]
    @StateObject private var viewModel = MainMenuViewModel()

    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer().frame(height: 20)
                header
                Spacer()
                recordPill
                    .offset(y: -40)
                    .onTapGesture { path.append(.stats) }
                summaryText
                    .padding(.top, 2)
                Spacer()
                playButton
                bottomLinks.padding(.top, 30)
            }
            .padding(.horizontal, 28)
            .padding(.top, 50)
            .padding(.bottom, 34)
        }
        .navigationBarHidden(true)
        .onAppear { viewModel.refresh() }
    }

    // MARK: - Sections

    private var header: some View {
        VStack(spacing: 14) {
            LogoView(fontSize: 86)
            Text(AppInfo.tagline)
                .font(Theme.display(17, weight: .medium))
                .foregroundStyle(Theme.textSecondary)
                .multilineTextAlignment(.center)
        }
    }

    private var recordPill: some View {
        HStack(spacing: 12) {
            pillIcon
            Text("\(pillLabel)  ·")
                .font(Theme.display(24, weight: .heavy))
                .foregroundStyle(Theme.textPrimary)
            Text("\(pillValue)")
                .font(Theme.display(24, weight: .heavy))
                .foregroundStyle(Theme.textPrimary)
                .lineLimit(1)
                .frame(minWidth: 34, alignment: .leading)
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 14)
        .background(
            Capsule()
                .fill(Theme.surface)
                .blur(radius: 10)
        )
        .animation(.easeOut(duration: 0.2), value: pillLabel)
    }

    private var isPracticeMode: Bool {
        if case .practice = viewModel.selectedMode { return true }
        return false
    }

    @ViewBuilder
    private var pillIcon: some View {
        if isPracticeMode {
            Image(systemName: "chart.bar.fill")
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(Theme.accent)
                .frame(width: 22, height: 22)
        } else {
            TrophyIcon(size: 22)
        }
    }

    private var pillLabel: String { isPracticeMode ? "Solved" : "Record" }
    private var pillValue: Int { isPracticeMode ? viewModel.practiceSolvedTotal : viewModel.bestScore }

    private var summaryText: some View {
        Text(viewModel.selectedMode.summary)
            .font(Theme.display(18, weight: .semibold))
            .foregroundStyle(Theme.textSecondary)
            .tracking(0.4)
            .animation(.easeOut(duration: 0.2), value: viewModel.selectedMode.summary)
    }

    private var playButton: some View {
        Button {
            path.append(.game(viewModel.selectedMode))
        } label: {
            Text("Play")
                .font(Theme.display(25, weight: .bold))
                .foregroundStyle(.white)
                .tracking(0.4)
                .frame(maxWidth: .infinity)
                .frame(height: 64)
                .background(
                    RoundedRectangle(cornerRadius: Theme.Radius.button)
                        .fill(Theme.accent)
                )
                .shadow(color: Theme.accent.opacity(0.5), radius: 14, x: 0, y: 8)
        }
        .buttonStyle(.plain)
    }

    private var bottomLinks: some View {
        HStack(spacing: 14) {
            linkButton(title: "Stats")    { path.append(.stats) }
            Text("·")
                .font(Theme.display(18, weight: .bold))
                .foregroundStyle(Theme.textSecondary)
            linkButton(title: "Settings") { path.append(.settings) }
        }
    }

    private func linkButton(title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(Theme.display(17, weight: .semibold))
                .foregroundStyle(Theme.textSecondary)
                .underline()
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    NavigationStack {
        MainMenuView(path: .constant([]))
    }
}
