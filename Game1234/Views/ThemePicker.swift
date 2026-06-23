// /Views/ThemePicker.swift
import SwiftUI

/// Пикер темы оформления (System / Light / Dark).
struct ThemePicker: View {
    @Binding var selection: AppTheme

    var body: some View {
        HStack(spacing: 8) {
            ForEach(AppTheme.allCases) { theme in
                ChipButton(title: theme.title,
                           subtitle: nil,
                           selected: selection == theme,
                           compact: true) {
                    selection = theme
                }
            }
        }
        .frame(height: 48)
    }
}
