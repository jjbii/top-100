//
//  AlbumListModelControllerTests.swift
//  Top 100Tests
//
//  Created by Jack Bransfield on 7/12/20.
//  Copyright © 2020 Built Light. All rights reserved.
//

import XCTest
@testable import Top_100

class AlbumListModelControllerTests: XCTestCase {

    // MARK: - Properties
    
    var bundle: Bundle {
        let t = type(of: self)
        let bundle = Bundle(for: t.self)
        return bundle
    }
    
    var modelController: AlbumListModelController!
        
    // MARK: - Setup & teardown

    override func setUpWithError() throws {
        let feed: AlbumFeed = self.bundle.decode(AlbumFeed.self, from: "AlbumFeed.json")
        self.modelController = AlbumListModelController(albumFeed: feed)
    }

    // MARK: - Tests
    
    func testFeed() throws {
        XCTAssertEqual(self.modelController.listTitle, "Top Albums")
        XCTAssertEqual(self.modelController.numberOfAlbums(), 100)
    }

    func testAlbumAtIndex() throws {
        let album74 = self.modelController.album(at: 74)!
        XCTAssertEqual(album74.id, "1499378108")
        XCTAssertEqual(album74.artistName, "The Weeknd")
        XCTAssertEqual(album74.name, "After Hours")
        
        let album38 = self.modelController.album(at: 38)!
        XCTAssertNotEqual(album38.id, "1499378108")
        XCTAssertNotEqual(album38.artistName, "The Weeknd")
        XCTAssertNotEqual(album38.name, "After Hours")
    }
    
    func testAlbumPropertyMethods() {
        XCTAssertEqual(self.modelController.albumName(for: 43), "Chromatica")
        XCTAssertEqual(self.modelController.artistName(for: 43), "Lady Gaga")
    }
}
