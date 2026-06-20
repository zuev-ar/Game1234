import SwiftUI

struct MainMenuView: View {
    @Binding var path: [Route]
    @StateObject private var viewModel = MainMenuViewModel()

    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer().frame(height: 20)

                VStack(spacing: 14) {
                    LogoView(fontSize: 86)
                    Text(AppInfo.tagline)
                        .font(.system(size: 17, weight: .medium))
                        .foregroundStyle(Theme.textSecondary)
                        .multilineTextAlignment(.center)
                }

                Spacer()

                recordPill

                Spacer()

                difficultyPicker
                    .padding(.bottom, 20)

                playButton

                settingsLink
                    .padding(.top, 16)
            }
            .padding(.horizontal, 28)
            .padding(.top, 50)
            .padding(.bottom, 34)

            aboutButton
        }
        .navigationBarHidden(true)
        .onAppear { viewModel.refresh() }
    }

    private var aboutButton: some View {
        VStack {
            HStack {
                Spacer()
                Button {
                    path.append(.about)
                } label: {
                    Image(systemName: "info.circle.fill")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundStyle(Theme.textSecondary)
                }
                .buttonStyle(.plain)
            }
            Spacer()
        }
        .padding(.horizontal, 28)
        .padding(.top, 16)
    }

    private var recordPill: some View {
        HStack(spacing: 12) {
            TrophyIcon(size: 22)
            Text("Record ·")
                .font(.system(size: 22, weight: .bold))
                .foregroundStyle(Theme.textPrimary)
            Text("\(viewModel.bestStreak)")
                .font(.system(size: 22, weight: .bold))
                .foregroundStyle(Theme.textPrimary)
                .lineLimit(1)
                .frame(minWidth: 34, alignment: .leading)
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 14)
        .background(
            Capsule()
                .fill(Theme.surface)
                .shadow(color: Color.black.opacity(0.08), radius: 10, x: 0, y: 4)
        )
    }

    private var difficultyPicker: some View {
        HStack(spacing: 10) {
            ForEach(Difficulty.allCases) { level in
                difficultyButton(level)
            }
        }
    }

    private func difficultyButton(_ level: Difficulty) -> some View {
        let selected = viewModel.difficulty == level
        return Button {
            viewModel.difficulty = level
        } label: {
            VStack(spacing: 2) {
                Text(level.title)
                    .font(.system(size: 16, weight: .bold))
                Text(level.subtitle)
                    .font(.system(size: 11, weight: .medium))
                    .opacity(0.85)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            .foregroundStyle(selected ? .white : Theme.textSecondary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: Theme.Radius.chip)
                    .fill(selected ? Theme.accent : Theme.surface)
                    .overlay(
                        RoundedRectangle(cornerRadius: Theme.Radius.chip)
                            .strokeBorder(selected ? Color.clear : Theme.hairline, lineWidth: 1)
                    )
            )
        }
        .buttonStyle(.plain)
        .animation(.easeOut(duration: 0.15), value: selected)
    }

    private var settingsLink: some View {
        Button {
            path.append(.settings)
        } label: {
            Text("Settings")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(Theme.textSecondary)
                .underline()
        }
        .buttonStyle(.plain)
    }

    private var playButton: some View {
        Button {
            path.append(.game(viewModel.difficulty))
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
}

#Preview {
    NavigationStack {
        MainMenuView(path: .constant([]))
    }
}
