//
//  DateFormatter+Additions.swift
//  Top 100Tests
//
//  Created by Jack Bransfield on 7/12/20.
//  Copyright © 2020 Built Light. All rights reserved.
//

import Foundation

extension DateFormatter {
    
    static var top100Formatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }
}
