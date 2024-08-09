//
//  WeightLineChart.swift
//  Step Tracker
//
//  Created by Nigel Wright on 8/8/24.
//

import SwiftUI
import Charts

struct WeightLineChart: View {
    
    var selectedMetric: HealthMetricContext
    var chartData: [HealthMetric]
    
    var body: some View {
        VStack {
            NavigationLink(value: selectedMetric) {
                HStack {
                    VStack(alignment: .leading) {
                        Label("Weight", systemImage: "figure")
                            .font(.title3.bold())
                            .foregroundStyle(.indigo)
                        Text("Avg: 180 lbs")
                            .font(.caption)
                    }
                    Spacer()
                    Image(systemName: "chevron.right")
                }
            }
            .foregroundStyle(.secondary)
            .padding(.bottom, 12)
            
            Chart {
                ForEach(chartData) { weight in
                    AreaMark(
                        x: .value("Day", weight.date, unit: .day),
                        y: .value("Value", weight.value)
                    )
                    .foregroundStyle(Gradient(colors: [.blue.opacity(0.5), .clear]))
                    
                    LineMark(
                        x: .value("Day", weight.date, unit: .day),
                        y: .value("Value", weight.value)
                    )
                    .foregroundStyle(.blue)
                }
            }
            .frame(height: 150)

        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemBackground)))
    }
}

#Preview {
    WeightLineChart(selectedMetric: .weight, chartData: MockData.weights)
}
