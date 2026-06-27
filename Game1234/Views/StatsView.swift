// /Views/StatsView.swift
import SwiftUI
import Charts

struct StatsView: View {
    @StateObject private var viewModel = StatsViewModel()

    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    filterPicker
                    metricsGrid
                    weeklyChartCard
                    historySection
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)
                .padding(.bottom, 40)
            }
        }
        .navigationTitle("Statistics")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { viewModel.refresh() }
    }

    // MARK: - Sections

    private var filterPicker: some View {
        SegmentedFilterPicker(
            items: StatsFilter.allCases,
            selection: $viewModel.filter,
            title: { $0.title }
        )
    }

    private var metricsGrid: some View {
        let cols = [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)]
        return LazyVGrid(columns: cols, spacing: 12) {
            MetricCard(title: "Total games", value: "\(viewModel.totalGames)")
            MetricCard(title: "Best score", value: "\(viewModel.bestScore)")
            MetricCard(title: "Best · week", value: "\(viewModel.bestThisWeek)")
            MetricCard(title: "Average", value: String(format: "%.1f", viewModel.averageScore))
            MetricCard(title: "Accuracy", value: String(format: "%.0f%%", viewModel.averageAccuracy))
            MetricCard(title: "Play time", value: viewModel.formattedDuration(viewModel.totalDuration))
        }
    }

    private var weeklyChartCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Games · last 7 days")
                .font(Theme.display(14, weight: .semibold))
                .foregroundStyle(Theme.textSecondary)

            Chart(viewModel.weeklyBuckets) { bucket in
                BarMark(
                    x: .value("Day", bucket.day, unit: .day),
                    y: .value("Games", bucket.games)
                )
                .foregroundStyle(Theme.accent)
                .cornerRadius(4)
            }
            .chartXAxis {
                AxisMarks(values: .stride(by: .day)) { value in
                    AxisValueLabel(format: .dateTime.weekday(.narrow))
                        .foregroundStyle(Theme.textSecondary)
                }
            }
            .chartYAxis {
                AxisMarks(position: .leading) { _ in
                    AxisGridLine().foregroundStyle(Theme.hairline)
                    AxisValueLabel().foregroundStyle(Theme.textSecondary)
                }
            }
            .frame(height: 140)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: Theme.Radius.chip)
                .fill(Theme.surface)
                .overlay(
                    RoundedRectangle(cornerRadius: Theme.Radius.chip)
                        .strokeBorder(Theme.hairline, lineWidth: 1)
                )
        )
    }

    private var historySection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("History")
                    .font(Theme.display(14, weight: .semibold))
                    .foregroundStyle(Theme.textSecondary)
                Spacer()
                if !viewModel.history.isEmpty {
                    Text("\(viewModel.history.count)")
                        .font(Theme.display(13, weight: .semibold))
                        .foregroundStyle(Theme.textSecondary)
                }
            }
            .padding(.horizontal, 4)

            if viewModel.history.isEmpty {
                emptyHistory
            } else {
                VStack(spacing: 0) {
                    ForEach(Array(viewModel.history.enumerated()), id: \.element.id) { idx, rec in
                        HistoryRow(record: rec)
                        if idx < viewModel.history.count - 1 {
                            Rectangle()
                                .fill(Theme.hairline)
                                .frame(height: 1)
                                .padding(.leading, 16)
                        }
                    }
                }
                .background(
                    RoundedRectangle(cornerRadius: Theme.Radius.chip)
                        .fill(Theme.surface)
                        .overlay(
                            RoundedRectangle(cornerRadius: Theme.Radius.chip)
                                .strokeBorder(Theme.hairline, lineWidth: 1)
                        )
                )
            }
        }
    }

    private var emptyHistory: some View {
        VStack(spacing: 6) {
            Text("No games yet")
                .font(Theme.display(15, weight: .semibold))
                .foregroundStyle(Theme.textPrimary)
            Text("Play a round to see it here")
                .font(Theme.display(13, weight: .regular))
                .foregroundStyle(Theme.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .background(
            RoundedRectangle(cornerRadius: Theme.Radius.chip)
                .fill(Theme.surface)
                .overlay(
                    RoundedRectangle(cornerRadius: Theme.Radius.chip)
                        .strokeBorder(Theme.hairline, lineWidth: 1)
                )
        )
    }
}

// MARK: - Components

private struct MetricCard: View {
    let title: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(Theme.display(12, weight: .semibold))
                .foregroundStyle(Theme.textSecondary)
                .tracking(0.3)
                .textCase(.uppercase)
            Text(value)
                .font(Theme.display(24, weight: .heavy))
                .foregroundStyle(Theme.textPrimary)
                .lineLimit(1)
                .minimumScaleFactor(0.6)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: Theme.Radius.chip)
                .fill(Theme.surface)
                .overlay(
                    RoundedRectangle(cornerRadius: Theme.Radius.chip)
                        .strokeBorder(Theme.hairline, lineWidth: 1)
                )
        )
    }
}

private struct HistoryRow: View {
    let record: GameRecord

    private static let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .short
        f.timeStyle = .short
        return f
    }()

    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(record.modeSummary)
                    .font(Theme.display(16, weight: .semibold))
                    .foregroundStyle(Theme.textPrimary)
                Text(Self.dateFormatter.string(from: record.date))
                    .font(Theme.display(12, weight: .semibold))
                    .foregroundStyle(Theme.textSecondary)
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 4) {
                Text("\(record.score)")
                    .font(Theme.display(16, weight: .heavy))
                    .foregroundStyle(Theme.textPrimary)
                if record.correctAnswers + record.wrongAnswers > 0 {
                    Text(String(format: "%.0f%%", record.accuracy))
                        .font(Theme.display(12, weight: .semibold))
                        .foregroundStyle(Theme.textSecondary)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}

#Preview {
    NavigationStack {
        StatsView()
    }
}
