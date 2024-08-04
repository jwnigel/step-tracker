//
//  DashboardView.swift
//  Step Tracker
//
//  Created by Nigel Wright on 7/20/24.
//

import SwiftUI


enum HealthMetric: CaseIterable, Identifiable {
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
    @AppStorage("hasSeenPermissionPriming") private var hasSeenPermissionPriming = false
    @State private var isShowingPermissionPrimingSheet = false
    @State private var selectedMetric: HealthMetric = .steps
    var isSteps: Bool { selectedMetric == .steps }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
        
                    Picker("Selected Metric", selection: $selectedMetric) {
                        ForEach(HealthMetric.allCases) { metric in
                            Text(metric.title)
                        }
                    }
                    .pickerStyle(.segmented)
                    
                    VStack {
                        NavigationLink(value: selectedMetric) {
                            HStack {
                                VStack(alignment: .leading) {
                                    Label("Steps", systemImage: "figure.walk")
                                        .font(.title3.bold())
                                        .foregroundStyle(.pink)
                                    Text("Avg 10k Steps")
                                        .font(.caption)
                                }
                                Spacer()
                                Image(systemName: "chevron.right")
                            }
                        }
                        .foregroundStyle(.secondary)
                        .padding(.bottom, 12)
                        
                        RoundedRectangle(cornerRadius: 12)
                            .foregroundStyle(.secondary)
                            .frame(height: 150)
                        
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemBackground)))
                    
                    
                    VStack(alignment: .leading) {
                        VStack(alignment: .leading) {
                            Label("Averages", systemImage: "calendar")
                                .font(.title3.bold())
                                .foregroundStyle(.pink)
                            Text("Last 28 Days")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.bottom, 12)
                        
                        
                        
                        RoundedRectangle(cornerRadius: 12)
                            .foregroundStyle(.secondary)
                            .frame(height: 240)
                        
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemBackground)))
                    
                }
            }
            .padding()
            .task {
//                await hkManager.addSimulatorData()
                isShowingPermissionPrimingSheet = !hasSeenPermissionPriming
            }
            .navigationTitle("Dashboard")
            .navigationDestination(for: HealthMetric.self) { metric in
                HealthDataListView(metric: metric)
            }
            .sheet(isPresented: $isShowingPermissionPrimingSheet, onDismiss: {
                // fetch health data
            }, content: {
                HealthkitPermissionPrimingView(hasSeen: $hasSeenPermissionPriming)
            })
        }
        .tint(isSteps ? .pink : .indigo)
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
            .environment(HealthKitManager())
    }
}
