//
//  DashboardView.swift
//  Step Tracker
//
//  Created by Nigel Wright on 7/20/24.
//

import SwiftUI
import Charts


enum HealthMetricContext: CaseIterable, Identifiable {
    case steps, weight
    var id: Self { self }
    var title: String {
        switch self {
        case .steps:
            return "Steps"
        case .weight:
            return "Weight"
        }
    }
}


struct DashboardView: View {
    
    @Environment(HealthKitManager.self) private var hkManager
    @State private var isShowingPermissionPrimingSheet = false
    @State private var selectedMetric: HealthMetricContext = .steps
    var isSteps: Bool { selectedMetric == .steps }
    
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    
                    Picker("Selected Metric", selection: $selectedMetric) {
                        ForEach(HealthMetricContext.allCases) { metric in
                            Text(metric.title)
                        }
                    }
                    .pickerStyle(.segmented)
                    
                    switch selectedMetric {
                    case .steps:
                        BarChartView(selectedMetric: selectedMetric, chartData: hkManager.stepData)
                        StepPieChart(chartData: ChartMath.averageWeekdayCount(for: hkManager.stepData))
                    case .weight:
                        WeightLineChart(selectedMetric: selectedMetric, chartData: hkManager.weightData)
                        WeightDiffChart(weightDiffData: ChartMath.averageDailyWeightDiffs(for: hkManager.weightDiffData))
                    }
                }
            }
            .padding()
            .task {
                do {
                    try await hkManager.fetchStepCount()
                    try await hkManager.fetchWeights()
                    try await hkManager.fetchWeightDiffData()
                } catch STError.authNotDetermined {
                    isShowingPermissionPrimingSheet = true
                } catch STError.noData {
                    print("❌ No Data Error")
                } catch {
                    print("❌ Unable to complete request")
                }

            }
            .navigationTitle("Dashboard")
            .navigationDestination(for: HealthMetricContext.self) { metric in
                HealthDataListView(metric: metric)
            }
            .sheet(isPresented: $isShowingPermissionPrimingSheet, onDismiss: {
                // fetch health data
            }, content: {
                HealthkitPermissionPrimingView()
            })
        }
        .tint(isSteps ? .pink : .indigo)
        
    }    
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
            .environment(HealthKitManager())
    }
}
