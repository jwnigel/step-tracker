//
//  HealthDataListView.swift
//  Step Tracker
//
//  Created by Nigel Wright on 7/30/24.
//

import SwiftUI

struct HealthDataListView: View {
    
    @State private var isShowingAddData: Bool = false
    @State private var addDataDate: Date = Date.now
    @State private var valueToAdd: String = ""
    
    var metric: selectedHealthMetric
    
    var body: some View {
        List(0..<28) { i in
            HStack {
                Text(Date(), format: .dateTime.month(.abbreviated).day().year())
                Spacer()
                Text(i, format: .number.precision(.fractionLength(metric == .steps ? 0 : 1)))
                
            }
        }
        .navigationTitle(metric.title)
        .sheet(isPresented: $isShowingAddData) {
            addDataView
        }
        .toolbar {
            Button("Add Data", systemImage: "plus") {
                isShowingAddData = true
            }
        }
        
        
    }
    
    var addDataView: some View {
        NavigationStack {
            Form {
                DatePicker("Date", selection: $addDataDate, displayedComponents: .date)
                HStack {
                    Text(metric.title)
                    Spacer()
                    TextField("Value", text: $valueToAdd)
                        .multilineTextAlignment(.trailing)
                        .frame(width: 200)
                        .keyboardType(metric == .steps ? .numberPad : .decimalPad)
                }
            }
            .navigationTitle(metric.title)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add Data") {
                        // TODO
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button("Dismiss") {
                        isShowingAddData = false
                    }
                }
            }
        }
    }
    
}

#Preview {
    HealthDataListView(metric: .weight)
}
