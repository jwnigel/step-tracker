//
//  Step_TrackerApp.swift
//  Step Tracker
//
//  Created by Nigel Wright on 7/20/24.
//

import SwiftUI

@main
struct Step_TrackerApp: App {
    
    let hkManager = HealthKitManager()
    
    var body: some Scene {
        WindowGroup {
            DashboardView()
                .environment(hkManager)
        }
    }
}
