//
//  AlbumListModelController.swift
//  Top 100
//
//  Created by Jack Bransfield on 7/11/20.
//  Copyright © 2020 Built Light. All rights reserved.
//

import Foundation

protocol AlbumListModelControllerDelegate: class {
    func albumListModelControllerDidUpdate(_ controller: AlbumListModelController)
    func albumListModelController(_ controller: AlbumListModelController, didReceiveError error: Error)
}

class AlbumListModelController {
    
    // MARK: - Properties

    private let iTunesApiService = iTunesAPIService()
    private var albumFeed: AlbumFeed?
    weak var delegate: AlbumListModelControllerDelegate?

    // MARK: - Initialization

    init(delegate: AlbumListModelControllerDelegate?) {
        self.delegate = delegate
        self.getAlbumFeed()
    }
    
    // MARK: - Public
    
    var listTitle: String? {
        return self.albumFeed?.title
    }
    
    func numberOfAlbums() -> Int {
        return self.albumFeed?.results.count ?? 0
    }
    
    func album(at index: Int) -> Album? {
        return self.albumFeed?.results[index]
    }
}

// MARK: - Private

private extension AlbumListModelController {
    
    func getAlbumFeed() {
        self.iTunesApiService.getAlbumFeed { [weak self] result in
            guard let strongSelf = self else { return }
            
            switch result {
            case .success(let albumFeed):
                strongSelf.albumFeed = albumFeed
                strongSelf.delegate?.albumListModelControllerDidUpdate(strongSelf)
            case .failure(let error):
                strongSelf.delegate?.albumListModelController(strongSelf, didReceiveError: error)
            }
        }
    }
}
