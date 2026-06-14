//
//  MainMenuView.swift
//  Game1234
//
//  Created by zuev_ar on 13.06.2026.
//

import SwiftUI

struct MainMenuView: View {
    @Binding var path: [Route]
    @StateObject private var viewModel = MainMenuViewModel()

    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer().frame(height: 34)

                VStack(spacing: 16) {
                    LogoView(fontSize: 86)
                    Text("Tap the answer. Beat the clock.")
                        .font(.system(size: 17, weight: .medium))
                        .foregroundStyle(Theme.textSecondary)
                }

                Spacer()

                recordPill

                Spacer()

                playButton

                aboutLink
                    .padding(.top, 18)
            }
            .padding(.horizontal, 28)
            .padding(.top, 66)
            .padding(.bottom, 34)
        }
        .navigationBarHidden(true)
        .onAppear { viewModel.refresh() }
    }

    private var recordPill: some View {
        HStack(spacing: 12) {
            TrophyIcon(size: 22)
            Text("Record · \(viewModel.bestStreak)")
                .font(.system(size: 22, weight: .bold))
                .foregroundStyle(Theme.textPrimary)
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 14)
        .background(
            Capsule().fill(Theme.trophy.opacity(0.18))
        )
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

    private var playButton: some View {
        Button {
            path.append(.game)
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
