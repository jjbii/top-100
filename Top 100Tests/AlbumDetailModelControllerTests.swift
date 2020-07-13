//
//  AlbumDetailModelControllerTests.swift
//  Top 100Tests
//
//  Created by Jack Bransfield on 7/12/20.
//  Copyright © 2020 Built Light. All rights reserved.
//

import XCTest
@testable import Top_100

class AlbumDetailModelControllerTests: XCTestCase {
    
    // MARK: - Properties
    
    var bundle: Bundle {
        let t = type(of: self)
        let bundle = Bundle(for: t.self)
        return bundle
    }

    var modelController: AlbumDetailModelController!

    // MARK: - Setup & teardown

    override func setUpWithError() throws {
        let album: Album = self.bundle.decode(Album.self, from: "Album.json")
        self.modelController = AlbumDetailModelController(album: album, rank: 67)
    }
    
    // MARK: - Tests

    func testAlbumProperties() {
        XCTAssertEqual(self.modelController.albumName, "Victory Lap")
        XCTAssertEqual(self.modelController.artistName, "Nipsey Hussle")
        XCTAssertEqual(
            self.modelController.copyrightInfo,
            "℗ 2018 All Money In No Money Out/Atlantic Recording Corporation for the United States and WEA International Inc. for the world outside of the United States.  A Warner Music Group Company."
        )
        XCTAssertEqual(
            self.modelController.appleMusicUrl,
            URL(string: "https://music.apple.com/us/album/victory-lap/1316706552?app=music")
        )
    }
    
    func testComputedValues() {
        XCTAssertEqual(self.modelController.releaseDate, "February 16, 2018")
        XCTAssertEqual(
            self.modelController.genres,
            "Hip-Hop/Rap, Music, West Coast Rap, Gangsta Rap, Hardcore Rap, Rap"
        )
    }
}
