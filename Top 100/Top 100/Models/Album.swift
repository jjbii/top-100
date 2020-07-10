//
//  Album.swift
//  Top 100
//
//  Created by Jack Bransfield on 7/10/20.
//  Copyright © 2020 Built Light. All rights reserved.
//

import Foundation

struct Album: Decodable {
    let id: String
    let name: String
    let artistName: String
    let genres: [Genre]
    let releaseDate: String
    let copyright: String
    let url: URL?
    let artworkUrl: URL?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case artistName
        case genres
        case releaseDate
        case copyright
        case url
        case artworkUrl = "artworkUrl100"
    }
}
