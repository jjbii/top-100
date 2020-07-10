//
//  Genre.swift
//  Top 100
//
//  Created by Jack Bransfield on 7/10/20.
//  Copyright © 2020 Built Light. All rights reserved.
//

import Foundation

struct Genre: Decodable {
    let id: String
    let name: String
    let url: URL?
    
    private enum CodingKeys: String, CodingKey {
        case id = "genreId"
        case name
        case url
    }
}
