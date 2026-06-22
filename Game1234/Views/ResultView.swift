import SwiftUI

struct ResultView: View {
    @Binding var path: [Route]
    let score: Int
    let isNewRecord: Bool
    let personalBest: Int
    let mode: GameMode

    private let feedback: FeedbackProviding = FeedbackCoordinator()

    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer().frame(height: 16)

                Text(isNewRecord ? "New Record!" : "Game Over")
                    .font(Theme.display(40, weight: .bold))
                    .foregroundStyle(isNewRecord ? Theme.accent : Theme.textPrimary)
                    .multilineTextAlignment(.center)
                    .transition(.scale.combined(with: .opacity))

                if isNewRecord {
                    TrophyIcon(size: 56)
                        .padding(.top, 20)
                }

                Text(mode.resultCaption)
                    .font(.system(size: 14, weight: .bold))
                    .tracking(2)
                    .foregroundStyle(Theme.textSecondary)
                    .padding(.top, 22)

                Text("\(score)")
                    .font(Theme.display(100, weight: .bold))
                    .foregroundStyle(Theme.numerals)

                Text("Personal Best · \(personalBest)")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(Theme.textSecondary)
                    .padding(.top, 8)

                Spacer()

                actionButtons
            }
            .padding(.horizontal, 28)
            .padding(.top, 48)
            .padding(.bottom, 32)

            if isNewRecord {
                ConfettiView()
                    .ignoresSafeArea()
                    .allowsHitTesting(false)
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            if isNewRecord { feedback.record() }
        }
    }

    private var actionButtons: some View {
        VStack(spacing: 12) {
            Button {
                path = [.game(mode)]
            } label: {
                Text("Play Again")
                    .font(Theme.display(23, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 62)
                    .background(
                        RoundedRectangle(cornerRadius: Theme.Radius.resultButton)
                            .fill(Theme.accent)
                    )
                    .shadow(color: Theme.accent.opacity(0.5), radius: 14, x: 0, y: 8)
            }
            .buttonStyle(.plain)

            Button {
                path = []
            } label: {
                Text("Menu")
                    .font(Theme.display(21, weight: .bold))
                    .foregroundStyle(Theme.accent)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(
                        RoundedRectangle(cornerRadius: Theme.Radius.resultButton)
                            .fill(Theme.accent.opacity(0.10))
                    )
            }
            .buttonStyle(.plain)
        }
    }
}

#Preview("Survival · Record") {
    NavigationStack {
        ResultView(path: .constant([]), score: 14, isNewRecord: true, personalBest: 14, mode: .survival(.easy))
    }
}

#Preview("Time Attack") {
    NavigationStack {
        ResultView(path: .constant([]), score: 22, isNewRecord: false, personalBest: 30, mode: .timeAttack(.easy, duration: .sixty))
    }
}
