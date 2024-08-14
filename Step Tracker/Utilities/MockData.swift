//
//  MockData.swift
//  Step Tracker
//
//  Created by Nigel Wright on 8/8/24.
//

import Foundation

struct MockData {
    
    static var steps: [HealthMetric] {
        var array: [HealthMetric] = []
        
        for i in 0..<28 {
            let metric = HealthMetric(date: Calendar.current.date(byAdding: .day, value: -i, to: .now)!, value: .random(in: 4_000...15_000))
            array.append(metric)
        }
        
        return array
    }
    
    static var weights: [HealthMetric] {
        var array: [HealthMetric] = []
        
        for i in 0..<28 {
            let metric = HealthMetric(date: Calendar.current.date(byAdding: .day, value: -i, to: .now)!, value: .random(in: 170 + Double(i/3) ... 175 + Double(i/3)))
            array.append(metric)
        }
        
        return array
    }
}
