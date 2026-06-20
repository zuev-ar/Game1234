import SwiftUI

struct GameView: View {
    @Binding var path: [Route]
    let difficulty: Difficulty
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
                    streakChip
                }
                .padding(.top, 18)

                problemBlock
                    .frame(maxHeight: .infinity)

                answerGrid
            }
            .padding(.horizontal, 24)
            .padding(.top, 18)
            .padding(.bottom, 32)
        }
        .navigationBarBackButtonHidden(true)
        .onAppear { viewModel.startGame(difficulty: difficulty) }
        .onDisappear { viewModel.stopGame() }
        .onChange(of: viewModel.currentProblem?.text) { _, _ in
            pressedIndex = nil
        }
        .onChange(of: viewModel.phase) { _, phase in
            if case .gameOver(let streak, let isNewRecord, let personalBest) = phase {
                path.append(.result(streak: streak, isNewRecord: isNewRecord, personalBest: personalBest, difficulty: difficulty))
            }
        }
    }

    // MARK: - Subviews

    private var streakChip: some View {
        HStack(alignment: .bottom, spacing: 8) {
            Text("Streak")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(Theme.textSecondary)
            Text("\(viewModel.streak)")
                .font(Theme.display(20, weight: .bold))
                .foregroundStyle(Theme.accent)
                .frame(minWidth: 28, alignment: .leading)
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 8)
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

#Preview {
    NavigationStack {
        GameView(path: .constant([.game(.easy)]), difficulty: .easy)
    }
}
