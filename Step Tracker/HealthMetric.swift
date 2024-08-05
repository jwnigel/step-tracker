//
//  HealthMetric.swift
//  Step Tracker
//
//  Created by Nigel Wright on 8/4/24.
//

import Foundation

struct HealthMetric: Identifiable {
    let id = UUID()
    let date: Date
    let value: Double
}
