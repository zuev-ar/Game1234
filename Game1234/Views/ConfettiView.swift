//
//  ConfettiView.swift
//  Game1234
//
//  Created by zuev_ar on 13.06.2026.
//

import SwiftUI

/// Конфетти как в макете: смесь форм (круг/квадрат/прямоугольник), разброс по всей ширине,
/// падение сверху вниз с вращением. Без сторонних библиотек.
struct ConfettiView: View {
    var particleCount: Int = 38

    @State private var isAnimating = false

    private let colors: [Color] = [
        Color(hex: 0xFF6B3D), Color(hex: 0xFFC53D), Color(hex: 0x16C172),
        Color(hex: 0x3DA0FF), Color(hex: 0xFF4D8D)
    ]

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .top) {
                ForEach(0..<particleCount, id: \.self) { i in
                    ConfettiPiece(
                        spec: spec(for: i, width: geo.size.width),
                        fallHeight: geo.size.height + 40,
                        isAnimating: isAnimating
                    )
                }
            }
        }
        .allowsHitTesting(false)
        .onAppear { isAnimating = true }
    }

    /// Детерминированные параметры частицы по индексу (без перегенерации при перерисовке).
    private func spec(for i: Int, width: CGFloat) -> ConfettiSpec {
        var rng = SeededRandom(seed: UInt64(i) &* 2654435761)
        let size = 7 + rng.next() * 9               // 7...16
        let isRound = rng.next() < 0.4              // 40% круглые
        let isSquare = !isRound && rng.next() < 0.4 // часть квадраты, остальное прямоугольники
        return ConfettiSpec(
            x: rng.next() * width,                   // разброс по всей ширине
            width: size,
            height: isRound || isSquare ? size : size * 0.55,
            color: colors[i % colors.count],
            cornerRadius: isRound ? size / 2 : 1.5,
            rotation: rng.next() * 360,
            delay: rng.next() * 0.9,
            duration: 1.9 + rng.next() * 1.7
        )
    }
}

private struct ConfettiSpec {
    let x: CGFloat
    let width: CGFloat
    let height: CGFloat
    let color: Color
    let cornerRadius: CGFloat
    let rotation: Double
    let delay: Double
    let duration: Double
}

private struct ConfettiPiece: View {
    let spec: ConfettiSpec
    let fallHeight: CGFloat
    let isAnimating: Bool

    @State private var spin: Double = 0

    var body: some View {
        RoundedRectangle(cornerRadius: spec.cornerRadius)
            .fill(spec.color)
            .frame(width: spec.width, height: spec.height)
            .rotationEffect(.degrees(spec.rotation + spin))
            .offset(x: spec.x, y: isAnimating ? fallHeight : -20)
            .opacity(isAnimating ? 0 : 1)
            .animation(.easeIn(duration: spec.duration).delay(spec.delay).repeatForever(autoreverses: false),
                       value: isAnimating)
            .onChange(of: isAnimating) { _, animating in
                guard animating else { return }
                withAnimation(.linear(duration: spec.duration).delay(spec.delay).repeatForever(autoreverses: false)) {
                    spin = Double.random(in: 360...720)
                }
            }
    }
}

/// Простой детерминированный ГПСЧ — стабильные частицы между перерисовками.
private struct SeededRandom {
    private var state: UInt64
    init(seed: UInt64) { state = seed == 0 ? 0x9E3779B9 : seed }
    mutating func next() -> Double {
        state ^= state << 13
        state ^= state >> 7
        state ^= state << 17
        return Double(state % 10000) / 10000.0
    }
}

#Preview {
    ConfettiView()
        .background(Color(white: 0.96))
}
