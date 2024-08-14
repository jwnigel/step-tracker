//
//  ChartDataTypes.swift
//  Step Tracker
//
//  Created by Nigel Wright on 8/7/24.
//

import Foundation

struct WeekdayChartData: Identifiable {
    let id = UUID()
    let date: Date
    let value: Double
}
