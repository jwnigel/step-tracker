//
//  HealthKitManager.swift
//  Step Tracker
//
//  Created by Nigel Wright on 8/2/24.
//

import Foundation
import HealthKit
import Observation


@Observable class HealthKitManager {
    let store = HKHealthStore()
    
    let types: Set = [HKQuantityType(.stepCount), HKQuantityType(.bodyMass)]
}
