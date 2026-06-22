import SwiftUI

struct SettingsView: View {
    @Binding var path: [Route]
    @StateObject private var viewModel = SettingsViewModel()

    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()

            VStack(spacing: 14) {
                toggleRow(
                    title: "Sound",
                    systemImage: "speaker.wave.2.fill",
                    isOn: $viewModel.soundEnabled
                )
                toggleRow(
                    title: "Haptics",
                    systemImage: "iphone.radiowaves.left.and.right",
                    isOn: $viewModel.hapticsEnabled
                )
                toggleRow(
                    title: "Countdown before start",
                    systemImage: "timer",
                    isOn: $viewModel.countdownEnabled
                )
                Spacer()
                aboutLink
                    .padding(.bottom, 24)
            }
            .padding(.horizontal, 24)
            .padding(.top, 24)
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
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
