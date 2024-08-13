//
//  WeightDiffChart.swift
//  Step Tracker
//
//  Created by Nigel Wright on 8/12/24.
//


import SwiftUI
import Charts

struct WeightDiffChart: View {
    
    @State private var rawSelectedDate: Date?
    
    var weightDiffData: [WeekdayChartData]
    
    var tappedWeekdayData: WeekdayChartData? {
        guard let rawSelectedDate else { return nil }
        return weightDiffData.first {
            Calendar.current.isDate(rawSelectedDate, inSameDayAs: $0.date)
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Label("Average Weight Change", systemImage: "figure")
                        .font(.title3.bold())
                        .foregroundStyle(.indigo)
                    Text("Per Weekday (Last 28 Days)")
                        .font(.caption)
                }
                Spacer()
            }
            .foregroundStyle(.secondary)
            .padding(.bottom, 12)
            
            Chart {
                if let tappedWeekdayData {
                    RuleMark(x: .value("Selected Data", tappedWeekdayData.date, unit: .day))
                        .foregroundStyle(Color.secondary.opacity(0.3))
                        .offset(y: -10)
                        .annotation(
                            position: .top,
                            spacing: 0,
                            overflowResolution: .init(x: .fit(to: .chart), y: .disabled))
                    { annotationView }
                }
                
                ForEach(weightDiffData) { weightDiff in
                    BarMark(
                        x: .value("Date", weightDiff.date, unit: .day),
                        y: .value("Steps", weightDiff.value)
                    )
                    .foregroundStyle(weightDiff.value > 0 ? Color.indigo : Color.mint)
                }
            }
            .chartXAxis {
                AxisMarks(values: .stride(by: .day)) { _ in
                    AxisValueLabel(format: .dateTime.weekday(), centered: true)
                }

            }
            .chartYAxis {
                AxisMarks { value in
                    AxisGridLine()
                        .foregroundStyle(Color.secondary.opacity(0.3))
                    
                    AxisValueLabel()
                }
            }
            .frame(height: 150)
            .chartXSelection(value: $rawSelectedDate.animation(.easeInOut))
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemBackground)))
    }
    
    var annotationView: some View {
        VStack(alignment: .leading) {
            Text(tappedWeekdayData?.date ?? .now, format:
                    .dateTime.weekday(.abbreviated))
            .font(.footnote.bold())
            .foregroundStyle(.secondary)
            
            Text(tappedWeekdayData?.value ?? 0, format: .number.precision(.fractionLength(1)))
                .fontWeight(.heavy)
                .foregroundStyle((tappedWeekdayData?.value ?? 0) > 0 ? .indigo : .mint)
            
        }
        .padding(12)
        .background(
        RoundedRectangle(cornerRadius: 4)
            .fill(Color(.secondarySystemBackground))
            .shadow(color: .secondary.opacity(0.3), radius: 2, x: 2, y: 2))
    }
}

#Preview {
    WeightDiffChart(weightDiffData: ChartMath.averageDailyWeightDiffs(for: MockData.weights))
}
