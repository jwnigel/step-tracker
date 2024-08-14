//
//  BarChartView.swift
//  Step Tracker
//
//  Created by Nigel Wright on 8/7/24.
//

import SwiftUI
import Charts

struct BarChartView: View {
    
    @State private var rawSelectedDate: Date?
    
    var selectedMetric: HealthMetricContext
    var chartData: [HealthMetric]
    
    var avgStepCount: Double {
        guard !chartData.isEmpty else { return 0 }
        let totalSteps = chartData.reduce(0) { subTotal, steps in
            subTotal + steps.value
        }
        return totalSteps / Double(chartData.count)
    }
    
    var tappedHealthMetric: HealthMetric? {
        guard let rawSelectedDate else { return nil }
        return chartData.first {
            Calendar.current.isDate(rawSelectedDate, inSameDayAs: $0.date)
        }
    }
    
    var body: some View {
        VStack {
            NavigationLink(value: selectedMetric) {
                HStack {
                    VStack(alignment: .leading) {
                        Label("Steps", systemImage: "figure.walk")
                            .font(.title3.bold())
                            .foregroundStyle(.pink)
                        Text("Avg: \(Int(avgStepCount))")
                            .font(.caption)
                    }
                    Spacer()
                    Image(systemName: "chevron.right")
                }
            }
            .foregroundStyle(.secondary)
            .padding(.bottom, 12)
            
            Chart {
                if let tappedHealthMetric {
                    RuleMark(x: .value("Tapped Metric", tappedHealthMetric.date, unit: .day))
                        .foregroundStyle(Color.secondary.opacity(0.3))
                        .offset(y: -10)
                        .annotation(
                            position: .top,
                            spacing: 0,
                            overflowResolution: .init(x: .fit(to: .chart), y: .disabled))
                    {
                        annotationView
                    }
                }
                
                RuleMark(y: .value("Average", avgStepCount))
                    .foregroundStyle(Color.secondary)
                    .lineStyle(.init(lineWidth: 1, dash: [4]))
                
                ForEach(chartData) { steps in
                    BarMark(
                        x: .value("Date", steps.date, unit: .day),
                        y: .value("Steps", steps.value)
                    )
                    .foregroundStyle(.pink.gradient)
                    .opacity(rawSelectedDate == nil || steps.date == tappedHealthMetric?.date ? 1.0 : 0.3)
                }
            }
            .chartXAxis {
                AxisMarks {
                    AxisValueLabel(format: .dateTime.month(.defaultDigits).day())
                }
            }
            .chartYAxis {
                AxisMarks { value in
                    AxisGridLine()
                        .foregroundStyle(Color.secondary.opacity(0.3))
                    
                    AxisValueLabel((value.as(Double.self) ?? 0).formatted(.number.notation(.compactName)))
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
            Text(tappedHealthMetric?.date ?? .now, format:
                    .dateTime.weekday(.abbreviated).month(.abbreviated).day())
            .font(.footnote.bold())
            .foregroundStyle(.secondary)
            
            Text(tappedHealthMetric?.value ?? 0, format: .number.precision(.fractionLength(0)))
                .fontWeight(.heavy)
                .foregroundStyle(.pink)
            
        }
        .padding(12)
        .background(
        RoundedRectangle(cornerRadius: 4)
            .fill(Color(.secondarySystemBackground))
            .shadow(color: .secondary.opacity(0.3), radius: 2, x: 2, y: 2))
    }
}

#Preview {
    BarChartView(selectedMetric: .steps, chartData: MockData.steps)
}
