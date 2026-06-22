import SwiftUI

/// Пикер длительности раунда Time Attack (60s / 90s).
struct DurationPicker: View {
    @Binding var selection: TimeAttackDuration

    var body: some View {
        HStack(spacing: 10) {
            ForEach(TimeAttackDuration.allCases) { dur in
                ChipButton(title: dur.title,
                           subtitle: nil,
                           selected: selection == dur,
                           compact: true) {
                    selection = dur
                }
            }
        }
    }
}
