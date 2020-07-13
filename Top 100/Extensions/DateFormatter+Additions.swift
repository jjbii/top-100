//
//  DateFormatter+Additions.swift
//  Top 100
//
//  Created by Jack Bransfield on 7/13/20.
//  Copyright © 2020 Built Light. All rights reserved.
//

import Foundation

extension DateFormatter {
    
    static var iTunesDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }
}
