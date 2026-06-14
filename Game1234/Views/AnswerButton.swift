//
//  AnswerButton.swift
//  Game1234
//
//  Created by zuev_ar on 13.06.2026.
//

import SwiftUI

/// Визуальное состояние кнопки ответа.
enum AnswerState {
    case idle
    case correct
    case wrong
}

/// Кнопка ответа с цифрой. Подсвечивается по результату: зелёным/красным.
struct AnswerButton: View {
    let number: Int
    let state: AnswerState
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text("\(number)")
                .font(Theme.display(46, weight: .bold))
                .foregroundStyle(foreground)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: Theme.Radius.answer)
                        .fill(background)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: Theme.Radius.answer)
                        .strokeBorder(state == .idle ? Theme.hairline : Color.clear, lineWidth: 1)
                )
                .shadow(color: shadowColor, radius: 0, x: 0, y: state == .idle ? 2 : 0)
                .scaleEffect(state == .idle ? 1 : 0.96)
                .animation(.easeOut(duration: 0.12), value: state)
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Ответ \(number)")
    }

    private var background: Color {
        switch state {
        case .idle:    return Theme.surface
        case .correct: return Theme.correct
        case .wrong:   return Theme.wrong
        }
    }

    private var foreground: Color {
        state == .idle ? Theme.numerals : .white
    }

    private var shadowColor: Color {
        state == .idle ? Color.black.opacity(0.05) : .clear
    }
}

#Preview {
    HStack {
        AnswerButton(number: 1, state: .idle, action: {})
        AnswerButton(number: 2, state: .correct, action: {})
        AnswerButton(number: 3, state: .wrong, action: {})
    }
    .frame(height: 90)
    .padding()
}
