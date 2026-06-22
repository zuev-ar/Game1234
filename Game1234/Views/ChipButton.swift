import SwiftUI

/// Базовая «таблетка» для пикеров главного меню (режим / длительность / сложность).
/// Унифицирует фон, рамку, цвет выбранного состояния и анимацию.
struct ChipButton: View {
    let title: String
    let subtitle: String?
    let selected: Bool
    var compact: Bool = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 2) {
                Text(title)
                    .font(.system(size: compact ? 15 : 16, weight: .bold))
                if let subtitle {
                    Text(subtitle)
                        .font(.system(size: 11, weight: .medium))
                        .opacity(0.85)
                        .lineLimit(1)
                        .minimumScaleFactor(0.75)
                }
            }
            .foregroundStyle(selected ? .white : Theme.textSecondary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, compact ? 10 : 12)
            .background(
                RoundedRectangle(cornerRadius: Theme.Radius.chip)
                    .fill(selected ? Theme.accent : Theme.surface)
                    .overlay(
                        RoundedRectangle(cornerRadius: Theme.Radius.chip)
                            .strokeBorder(selected ? Color.clear : Theme.hairline, lineWidth: 1)
                    )
            )
        }
        .buttonStyle(.plain)
        .animation(.easeOut(duration: 0.15), value: selected)
    }
}

#Preview {
    HStack(spacing: 10) {
        ChipButton(title: "Survival", subtitle: "One mistake — game over", selected: true) {}
        ChipButton(title: "Time Attack", subtitle: "Score as much as you can", selected: false) {}
    }
    .padding()
}
