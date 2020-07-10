//
//  AlbumFeed.swift
//  Top 100
//
//  Created by Jack Bransfield on 7/10/20.
//  Copyright © 2020 Built Light. All rights reserved.
//

import Foundation

struct AlbumFeed: Decodable {
    let title: String
    let results: [Album]
    
    private enum CodingKeys: String, CodingKey {
        case feed
        case title
        case results
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let feed = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .feed)
        title = try feed.decode(String.self, forKey: .title)
        results = try feed.decode([Album].self, forKey: .results)
    }
}
