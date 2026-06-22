import SwiftUI

/// Пикер игрового режима (Survival / Time Attack).
struct ModePicker: View {
    @Binding var selection: GameMode.Kind

    var body: some View {
        HStack(spacing: 10) {
            ForEach(GameMode.Kind.allCases) { kind in
                ChipButton(title: kind.title,
                           subtitle: kind.subtitle,
                           selected: selection == kind) {
                    selection = kind
                }
            }
        }
    }
}

#Preview {
    StatefulPreviewWrapper(GameMode.Kind.survival) { binding in
        ModePicker(selection: binding).padding()
    }
}

/// Утилита для превью с @State-биндингом.
private struct StatefulPreviewWrapper<Value, Content: View>: View {
    @State private var value: Value
    let content: (Binding<Value>) -> Content
    init(_ value: Value, @ViewBuilder content: @escaping (Binding<Value>) -> Content) {
        _value = State(initialValue: value)
        self.content = content
    }
    var body: some View { content($value) }
}
