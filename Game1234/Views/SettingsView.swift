import SwiftUI

struct SettingsView: View {
    @Binding var path: [Route]
    @StateObject private var viewModel = SettingsViewModel()

    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 22) {
                    togglesSection
                    modeSection
                    durationSection
                    difficultySection
                    themeSection
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)
                .padding(.bottom, 24)
            }

            VStack {
                Spacer()
                aboutLink.padding(.bottom, 12)
            }
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Sections

    private var togglesSection: some View {
        VStack(spacing: 14) {
            toggleRow(title: "Sound",
                      systemImage: "speaker.wave.2.fill",
                      isOn: $viewModel.soundEnabled)
            toggleRow(title: "Haptics",
                      systemImage: "iphone.radiowaves.left.and.right",
                      isOn: $viewModel.hapticsEnabled)
            toggleRow(title: "Countdown before start",
                      systemImage: "timer",
                      isOn: $viewModel.countdownEnabled)
        }
    }

    private var themeSection: some View {
        section("APPEARANCE") {
            ThemePicker(selection: $viewModel.appTheme)
        }
    }

    private var modeSection: some View {
        section("GAME MODE") {
            ModePicker(selection: $viewModel.modeKind)
        }
    }

    /// Кнопки длительности TA показываются всегда, но неактивны вне Time Attack.
    private var durationSection: some View {
        let isActive = viewModel.modeKind == .timeAttack
        return section("TIME ATTACK DURATION") {
            DurationPicker(selection: $viewModel.timeAttackDuration)
                .disabled(!isActive)
                .opacity(isActive ? 1.0 : 0.4)
                .animation(.easeOut(duration: 0.2), value: isActive)
        }
    }

    private var difficultySection: some View {
        section("DIFFICULTY") {
            DifficultyPicker(selection: $viewModel.difficulty)
        }
    }

    // MARK: - Components

    private func section<Content: View>(_ title: String,
                                        @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.system(size: 12, weight: .bold))
                .tracking(1.6)
                .foregroundStyle(Theme.textSecondary)
                .padding(.leading, 4)
            content()
        }
    }

    private var aboutLink: some View {
        Button {
            path.append(.about)
        } label: {
            Text("About")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(Theme.textSecondary)
                .underline()
        }
        .buttonStyle(.plain)
    }

    private func toggleRow(title: String, systemImage: String, isOn: Binding<Bool>) -> some View {
        HStack(spacing: 14) {
            Image(systemName: systemImage)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(Theme.accent)
                .frame(width: 28)
            Text(title)
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(Theme.textPrimary)
            Spacer()
            Toggle("", isOn: isOn)
                .labelsHidden()
                .tint(Theme.accent)
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: Theme.Radius.chip)
                .fill(Theme.surface)
                .overlay(
                    RoundedRectangle(cornerRadius: Theme.Radius.chip)
                        .strokeBorder(Theme.hairline, lineWidth: 1)
                )
        )
    }
}

#Preview {
    NavigationStack {
        SettingsView(path: .constant([]))
    }
}
