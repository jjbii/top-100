//
//  Bundle+Additions.swift
//  Top 100Tests
//
//  Created by Jack Bransfield on 7/12/20.
//  Copyright © 2020 Built Light. All rights reserved.
//

import Foundation
@testable import Top_100

extension Bundle {
    
    /// A helper method for instantiating a Decodable model from a JSON file.
    func decode<T: Decodable>(_ type: T.Type, from file: String) -> T {
        
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file) in bundle.")
        }

        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) from bundle.")
        }

        let dateFormatter = DateFormatter.iTunesDateFormatter
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        do {
            return try decoder.decode(T.self, from: data)
        } catch let error {
            fatalError("Failed to decode \(file) from bundle: \(error.localizedDescription)")
        }
    }
}
