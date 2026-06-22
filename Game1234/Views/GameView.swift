import SwiftUI

struct GameView: View {
    @Binding var path: [Route]
    let mode: GameMode
    @StateObject private var viewModel = GameViewModel()

    private let feedback: FeedbackProviding = FeedbackCoordinator()

    /// Индекс нажатой кнопки (для подсветки на ~200мс перед сменой примера).
    @State private var pressedIndex: Int?

    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()

            VStack(spacing: 0) {
                TimerBar(progress: viewModel.timeProgress)

                HStack {
                    Spacer()
                    scoreChip
                }
                .padding(.top, 18)

                problemBlock
                    .frame(maxHeight: .infinity)

                answerGrid
            }
            .padding(.horizontal, 24)
            .padding(.top, 18)
            .padding(.bottom, 32)

            countdownOverlay
        }
        .animation(.easeOut(duration: 0.35), value: viewModel.countdownValue)
        .navigationBarBackButtonHidden(true)
        .onAppear { viewModel.startGame(mode: mode) }
        .onDisappear { viewModel.stopGame() }
        .onChange(of: viewModel.currentProblem?.text) { _, _ in
            pressedIndex = nil
        }
        .onChange(of: viewModel.phase) { _, phase in
            if case .gameOver(let score, let isNewRecord, let personalBest) = phase {
                path.append(.result(score: score, isNewRecord: isNewRecord, personalBest: personalBest, mode: mode))
            }
        }
    }

    // MARK: - Subviews

    @ViewBuilder
    private var countdownOverlay: some View {
        if let value = viewModel.countdownValue {
            ZStack {
                Theme.background.ignoresSafeArea()
                Text("\(value)")
                    .font(Theme.display(180, weight: .bold))
                    .foregroundStyle(Theme.accent)
                    .id(value)
                    .transition(.asymmetric(
                        insertion: .scale(scale: 0.4).combined(with: .opacity),
                        removal: .scale(scale: 1.4).combined(with: .opacity)
                    ))
                    .animation(.spring(response: 0.35, dampingFraction: 0.7), value: value)
            }
            .transition(.opacity)
        }
    }

    private var scoreChip: some View {
        HStack(alignment: .bottom, spacing: 8) {
            Text(scoreLabel)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(Theme.textSecondary)
            Text("\(viewModel.score)")
                .font(Theme.display(20, weight: .bold))
                .foregroundStyle(Theme.accent)
                .frame(minWidth: 28, alignment: .leading)
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 8)
    }

    private var scoreLabel: String {
        switch mode {
        case .survival:   return "Streak"
        case .timeAttack: return "Score"
        }
    }

    private var problemBlock: some View {
        VStack(spacing: 4) {
            Text(viewModel.currentProblem?.text ?? " ")
                .font(Theme.display(86, weight: .bold))
                .foregroundStyle(Theme.numerals)
                .tracking(1)
                .minimumScaleFactor(0.5)
                .lineLimit(1)
                .id(viewModel.currentProblem?.text)
                .transition(.asymmetric(
                    insertion: .scale(scale: 0.7).combined(with: .opacity),
                    removal: .opacity
                ))
                .animation(.spring(response: 0.3, dampingFraction: 0.7),
                           value: viewModel.currentProblem?.text)

            Text("= ?")
                .font(Theme.display(30, weight: .bold))
                .foregroundStyle(Theme.textSecondary)
        }
    }

    private var answerGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible(), spacing: 14),
                            GridItem(.flexible(), spacing: 14)], spacing: 14) {
            ForEach(Array(options.enumerated()), id: \.offset) { index, value in
                AnswerButton(value: value, state: stateFor(index)) {
                    handleTap(index)
                }
                .frame(height: 96)
            }
        }
    }

    // MARK: - Logic

    private var options: [Int] {
        viewModel.currentProblem?.options ?? [0, 0, 0, 0]
    }

    private func stateFor(_ index: Int) -> AnswerState {
        guard let pressedIndex, let problem = viewModel.currentProblem else { return .idle }
        if index == problem.correctIndex { return .correct }   // верный всегда зелёный после нажатия
        if index == pressedIndex { return .wrong }             // ошибочно нажатый — красный
        return .idle
    }

    private func handleTap(_ index: Int) {
        guard pressedIndex == nil,
              let problem = viewModel.currentProblem,
              viewModel.phase == .playing else { return }

        let isCorrect = index == problem.correctIndex
        pressedIndex = index
        isCorrect ? feedback.correct() : feedback.wrong()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            viewModel.optionSelected(at: index)
        }
    }
}

#Preview("Survival") {
    NavigationStack {
        GameView(path: .constant([.game(.survival(.easy))]), mode: .survival(.easy))
    }
}

#Preview("Time Attack") {
    NavigationStack {
        GameView(path: .constant([.game(.timeAttack(.easy, duration: .sixty))]),
                 mode: .timeAttack(.easy, duration: .sixty))
    }
}
