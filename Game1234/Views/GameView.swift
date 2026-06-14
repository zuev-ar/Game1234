//
//  GameView.swift
//  Game1234
//
//  Created by zuev_ar on 13.06.2026.
//

import SwiftUI

struct GameView: View {
    @Binding var path: [Route]
    @StateObject private var viewModel = GameViewModel()

    private let haptics: HapticFeedbackProviding = HapticFeedback()

    /// Нажатая кнопка и её корректность — для подсветки на ~200мс перед сменой примера.
    @State private var pressed: (number: Int, isCorrect: Bool)?

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
        .onAppear { viewModel.startGame() }
        .onDisappear { viewModel.stopGame() }
        .onChange(of: viewModel.currentProblem?.text) { _, _ in
            pressed = nil
        }
        .onChange(of: viewModel.phase) { _, phase in
            if case .gameOver(let streak, let isNewRecord, let personalBest) = phase {
                path.append(.result(streak: streak, isNewRecord: isNewRecord, personalBest: personalBest))
            }
        }
    }

    // MARK: - Subviews

    private var streakChip: some View {
        HStack(alignment: .firstTextBaseline, spacing: 8) {
            Text("Streak")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(Theme.textSecondary)
            Text("\(viewModel.streak)")
                .font(Theme.display(22, weight: .bold))
                .foregroundStyle(Theme.accent)
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: Theme.Radius.chip)
                .fill(Theme.surface)
                .overlay(
                    RoundedRectangle(cornerRadius: Theme.Radius.chip)
                        .strokeBorder(Theme.hairline, lineWidth: 1)
                )
        )
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
            ForEach(1...4, id: \.self) { number in
                AnswerButton(number: number, state: stateFor(number)) {
                    handleTap(number)
                }
                .frame(height: 96)
            }
        }
    }

    // MARK: - Logic

    private func stateFor(_ number: Int) -> AnswerState {
        guard let pressed, pressed.number == number else { return .idle }
        return pressed.isCorrect ? .correct : .wrong
    }

    private func handleTap(_ number: Int) {
        guard pressed == nil,
              let problem = viewModel.currentProblem,
              viewModel.phase == .playing else { return }

        let isCorrect = number == problem.answer
        pressed = (number, isCorrect)
        isCorrect ? haptics.success() : haptics.error()

        // Подсветка держится ~200мс, затем уходим в VM.
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            viewModel.answerSelected(number)
        }
    }
}

#Preview {
    NavigationStack {
        GameView(path: .constant([.game]))
    }
}
