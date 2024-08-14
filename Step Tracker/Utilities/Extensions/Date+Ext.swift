//
//  Date+Ext.swift
//  Step Tracker
//
//  Created by Nigel Wright on 8/7/24.
//

import Foundation

extension Date {
    var weekdayInt: Int {
        Calendar.current.component(.weekday, from: self)
    }
    
    var weekdayTitle: String {
        self.formatted(.dateTime.weekday(.wide))
    }
}
