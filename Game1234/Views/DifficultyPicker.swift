import SwiftUI

/// Пикер сложности (Easy / Medium / Hard).
struct DifficultyPicker: View {
    @Binding var selection: Difficulty

    var body: some View {
        HStack(spacing: 10) {
            ForEach(Difficulty.allCases) { level in
                ChipButton(title: level.title,
                           subtitle: level.subtitle,
                           selected: selection == level) {
                    selection = level
                }
            }
        }
    }
}
