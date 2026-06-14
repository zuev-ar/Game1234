//
//  ResultView.swift
//  Game1234
//
//  Created by zuev_ar on 13.06.2026.
//

import SwiftUI

struct ResultView: View {
    @Binding var path: [Route]
    let streak: Int
    let isNewRecord: Bool
    let personalBest: Int

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

                Text("FINAL STREAK")
                    .font(.system(size: 14, weight: .bold))
                    .tracking(2)
                    .foregroundStyle(Theme.textSecondary)
                    .padding(.top, 22)

                Text("\(streak)")
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
    }

    private var actionButtons: some View {
        VStack(spacing: 12) {
            Button {
                path = [.game]
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

#Preview("New Record") {
    NavigationStack {
        ResultView(path: .constant([]), streak: 14, isNewRecord: true, personalBest: 14)
    }
}

#Preview("Personal Best") {
    NavigationStack {
        ResultView(path: .constant([]), streak: 5, isNewRecord: false, personalBest: 14)
    }
}
