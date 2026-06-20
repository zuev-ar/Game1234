import SwiftUI

struct AboutView: View {
    @Environment(\.openURL) private var openURL

    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 28) {
                    header
                    description
                    infoCard
                    links
                    Text(AppInfo.copyright)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(Theme.textSecondary)
                        .padding(.top, 4)
                }
                .padding(.horizontal, 28)
                .padding(.top, 24)
                .padding(.bottom, 40)
            }
        }
        .navigationTitle("About")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Sections

    private var header: some View {
        VStack(spacing: 14) {
            LogoView(fontSize: 66)
            Text("Version \(AppInfo.version) (\(AppInfo.build))")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(Theme.textSecondary)
        }
        .padding(.top, 8)
    }

    private var description: some View {
        Text(AppInfo.about)
            .font(.system(size: 16, weight: .regular))
            .foregroundStyle(Theme.textPrimary)
            .multilineTextAlignment(.center)
            .lineSpacing(3)
    }

    private var infoCard: some View {
        VStack(spacing: 0) {
            infoRow(label: "Developer", value: AppInfo.author)
            divider
            infoRow(label: "Version", value: "\(AppInfo.version) (\(AppInfo.build))")
        }
        .background(
            RoundedRectangle(cornerRadius: Theme.Radius.chip)
                .fill(Theme.surface)
                .overlay(
                    RoundedRectangle(cornerRadius: Theme.Radius.chip)
                        .strokeBorder(Theme.hairline, lineWidth: 1)
                )
        )
    }

    private var links: some View {
        VStack(spacing: 12) {
            linkButton(title: "Contact", systemImage: "envelope.fill") {
                openURL(URL(string: "mailto:\(AppInfo.contactEmail)")!)
            }
//            linkButton(title: "Privacy Policy", systemImage: "lock.shield.fill") {
//                if let url = URL(string: AppInfo.privacyURL) { openURL(url) }
//            }
        }
    }

    // MARK: - Components

    private func infoRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(Theme.textSecondary)
            Spacer()
            Text(value)
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(Theme.textPrimary)
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 15)
    }

    private var divider: some View {
        Rectangle()
            .fill(Theme.hairline)
            .frame(height: 1)
            .padding(.leading, 18)
    }

    private func linkButton(title: String, systemImage: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 10) {
                Image(systemName: systemImage)
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Theme.textSecondary)
            }
            .foregroundStyle(Theme.accent)
            .padding(.horizontal, 18)
            .padding(.vertical, 15)
            .background(
                RoundedRectangle(cornerRadius: Theme.Radius.chip)
                    .fill(Theme.accent.opacity(0.10))
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    NavigationStack {
        AboutView()
    }
}
