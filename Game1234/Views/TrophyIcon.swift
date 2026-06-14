//
//  TrophyIcon.swift
//  Game1234
//
//  Created by zuev_ar on 14.06.2026.
//

import SwiftUI

/// Трофей из макета: U-образная чаша (верх слегка скруглён, низ сильно) + ножка + основание.
struct TrophyIcon: View {
    /// Ширина чаши; остальное масштабируется относительно неё.
    var size: CGFloat = 56

    var body: some View {
        VStack(spacing: 0) {
            // Чаша: радиусы верх 0.25·, низ 0.5· (как 14/28 при size 56).
            UnevenRoundedRectangle(
                topLeadingRadius: size * 0.25,
                bottomLeadingRadius: size * 0.5,
                bottomTrailingRadius: size * 0.5,
                topTrailingRadius: size * 0.25
            )
            .fill(Theme.trophy)
            .frame(width: size, height: size * 0.7)

            // Ножка — темнее.
            Rectangle()
                .fill(Color(hex: 0xE0A02F))
                .frame(width: size * 0.21, height: size * 0.16)

            // Основание.
            RoundedRectangle(cornerRadius: size * 0.07)
                .fill(Theme.trophy)
                .frame(width: size * 0.75, height: size * 0.16)
        }
    }
}

#Preview {
    HStack(spacing: 24) {
        TrophyIcon(size: 16)
        TrophyIcon(size: 56)
    }
    .padding()
}
