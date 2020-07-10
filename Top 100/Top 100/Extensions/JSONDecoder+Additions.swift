//
//  JSONDecoder+Additions.swift
//  Top 100
//
//  Created by Jack Bransfield on 7/10/20.
//  Copyright © 2020 Built Light. All rights reserved.
//

import Foundation

extension JSONDecoder {
    
    static func albumFeedDecoder() -> JSONDecoder {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        return decoder
    }
}
