//
//  LogoView.swift
//  Game1234
//
//  Created by zuev_ar on 13.06.2026.
//

import SwiftUI

/// Лого "1·2·3·4": тёмные цифры, оранжевые точки-разделители.
struct LogoView: View {
    var fontSize: CGFloat = 58

    var body: some View {
        HStack(spacing: 2) {
            digit(1); dot(); digit(2); dot(); digit(3); dot(); digit(4)
        }
    }

    private func digit(_ n: Int) -> some View {
        Text("\(n)")
            .font(Theme.display(fontSize, weight: .bold))
            .foregroundStyle(Theme.textPrimary)
    }

    private func dot() -> some View {
        Text("·")
            .font(Theme.display(fontSize * 0.7, weight: .bold))
            .foregroundStyle(Theme.accent)
    }
}

#Preview {
    LogoView()
        .padding()
}
