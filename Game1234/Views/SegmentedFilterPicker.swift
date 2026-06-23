// /Views/SegmentedFilterPicker.swift
import SwiftUI

/// Кастомный сегмент-пикер с фирменным шрифтом Theme.display.
struct SegmentedFilterPicker<Item: Hashable & Identifiable>: View {
    let items: [Item]
    @Binding var selection: Item
    let title: (Item) -> String

    @Namespace private var ns

    var body: some View {
        HStack(spacing: 4) {
            ForEach(items) { item in
                segment(item)
            }
        }
        .padding(4)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Theme.track)
        )
        .animation(.spring(response: 0.28, dampingFraction: 0.85), value: selection)
    }

    private func segment(_ item: Item) -> some View {
        let isSelected = item == selection
        return Button {
            selection = item
        } label: {
            Text(title(item))
                .font(Theme.display(13, weight: .semibold))
                .foregroundStyle(isSelected ? .white : Theme.textSecondary)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .background(
                    ZStack {
                        if isSelected {
                            RoundedRectangle(cornerRadius: 9)
                                .fill(Theme.accent)
                                .shadow(color: Theme.accent.opacity(0.35), radius: 4, y: 2)
                                .matchedGeometryEffect(id: "seg", in: ns)
                        }
                    }
                )
        }
        .buttonStyle(.plain)
    }
}
