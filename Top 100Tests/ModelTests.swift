//
//  ModelTests.swift
//  Top 100Tests
//
//  Created by Jack Bransfield on 7/12/20.
//  Copyright © 2020 Built Light. All rights reserved.
//

import XCTest
@testable import Top_100

class ModelTests: XCTestCase {

    // MARK: - Properties
    
    var bundle: Bundle {
        let t = type(of: self)
        let bundle = Bundle(for: t.self)
        return bundle
    }
        
    // MARK: - Tests
    
    func testGenre() throws {
        let genre: Genre = self.bundle.decode(Genre.self, from: "Genre.json")
        XCTAssertEqual(genre.name, "Alternative Rap")
        XCTAssertEqual(genre.id, "1068")
        XCTAssertEqual(genre.url, URL(string: "https://itunes.apple.com/us/genre/id1068"))
    }
    
    func testAlbum() throws {
        let album: Album = self.bundle.decode(Album.self, from: "Album.json")
        XCTAssertEqual(album.id, "1316706552")
        XCTAssertEqual(album.name, "Victory Lap")
        XCTAssertEqual(album.artistName, "Nipsey Hussle")
        XCTAssertEqual(album.genres.count, 6)
        XCTAssertEqual(
            album.releaseDate,
            DateFormatter.iTunesDateFormatter.date(from: "2018-02-16")
        )
        XCTAssertEqual(
            album.copyright,
            "℗ 2018 All Money In No Money Out/Atlantic Recording Corporation for the United States and WEA International Inc. for the world outside of the United States.  A Warner Music Group Company."
        )
        XCTAssertEqual(
            album.url,
            URL(string: "https://music.apple.com/us/album/victory-lap/1316706552?app=music")
        )
        XCTAssertEqual(
            album.artworkUrl,
            URL(string: "https://is1-ssl.mzstatic.com/image/thumb/Music118/v4/aa/d0/2c/aad02cb6-a81c-6554-af9b-4bd3b8f2745d/075679884732.jpg/200x200bb.png")
        )
    }
    
    func testAlbumFeed() throws {
        let feed: AlbumFeed = self.bundle.decode(AlbumFeed.self, from: "AlbumFeed.json")
        XCTAssertEqual(feed.title, "Top Albums")
        XCTAssertEqual(feed.results.count, 100)
        XCTAssertEqual(feed.results[13].name, "Barnacles")
    }
}
