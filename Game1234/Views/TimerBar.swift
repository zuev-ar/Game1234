//
//  TimerBar.swift
//  Game1234
//
//  Created by zuev_ar on 13.06.2026.
//

import SwiftUI

/// Полоса таймера: заполнение по доле оставшегося времени, цвет зелёный → жёлтый → красный.
struct TimerBar: View {
    let progress: Double

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule().fill(Theme.track)
                Capsule()
                    .fill(color)
                    .frame(width: geo.size.width * progress)
                    .animation(.linear(duration: 0.12), value: progress)
            }
        }
        .frame(height: 14)
    }

    private var color: Color {
        if progress > 0.5 {
            return blend(Theme.timerYellow, Theme.timerGreen, t: (progress - 0.5) / 0.5)
        }
        return blend(Theme.timerRed, Theme.timerYellow, t: progress / 0.5)
    }

    private func blend(_ from: Color, _ to: Color, t: Double) -> Color {
        let f = UIColor(from), tc = UIColor(to)
        var fr: CGFloat = 0, fg: CGFloat = 0, fb: CGFloat = 0, fa: CGFloat = 0
        var tr: CGFloat = 0, tg: CGFloat = 0, tb: CGFloat = 0, ta: CGFloat = 0
        f.getRed(&fr, green: &fg, blue: &fb, alpha: &fa)
        tc.getRed(&tr, green: &tg, blue: &tb, alpha: &ta)
        let k = CGFloat(max(0, min(1, t)))
        return Color(red: Double(fr + (tr - fr) * k),
                     green: Double(fg + (tg - fg) * k),
                     blue: Double(fb + (tb - fb) * k))
    }
}

#Preview {
    VStack(spacing: 20) {
        TimerBar(progress: 1.0)
        TimerBar(progress: 0.5)
        TimerBar(progress: 0.15)
    }
    .padding()
}
