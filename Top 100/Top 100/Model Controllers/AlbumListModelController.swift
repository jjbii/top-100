//
//  AlbumListModelController.swift
//  Top 100
//
//  Created by Jack Bransfield on 7/11/20.
//  Copyright © 2020 Built Light. All rights reserved.
//

import UIKit

protocol AlbumListModelControllerDelegate: class {
    func albumListModelControllerDidUpdate(_ controller: AlbumListModelController)
    func albumListModelController(_ controller: AlbumListModelController, didReceiveError error: Error)
    func albumListModelController(_ controller: AlbumListModelController, didReceiveImage image: UIImage, forAlbumAt index: Int)
}

class AlbumListModelController {
    
    // MARK: - Properties

    weak var delegate: AlbumListModelControllerDelegate?

    private let albumFeedService = AlbumFeedService()
    private var albumFeed: AlbumFeed?
    private let artworkService = AlbumArtworkService.shared
    private var albumArtworkObserver: NSObjectProtocol?

    // MARK: - Initialization

    init() {
        self.addNotificationObservers()
    }
    
    deinit {
        self.removeNotificationObservers()
    }
    
    // MARK: - Public
    
    func getAlbumFeed() {
        self.albumFeedService.getAlbumFeed { [weak self] result in
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

    var listTitle: String? {
        return self.albumFeed?.title
    }
    
    func numberOfAlbums() -> Int {
        return self.albumFeed?.results.count ?? 0
    }
    
    func album(at index: Int) -> Album? {
        return self.albumFeed?.results[index]
    }
    
    func albumName(for index: Int) -> String? {
        return self.albumFeed?.results[index].name
    }
    
    func artistName(for index: Int) -> String? {
        return self.albumFeed?.results[index].artistName
    }
    
    func artwork(for index: Int) -> UIImage?  {
        guard let album = self.album(at: index) else { return nil }
        return self.artworkService.artwork(for: album)
    }
    
    func prefetchArtwork(for indexes: [Int]) {
        for index in indexes {
            let _ = self.artwork(for: index)
        }
    }
    
    func cancelPrefetching(for indexes: [Int]) {
        for index in indexes {
            guard let album = self.album(at: index) else { continue }
            self.artworkService.cancelPrefetchRequest(for: album)
        }
    }
}

// MARK: - Private

private extension AlbumListModelController {
        
    func addNotificationObservers() {
        let nc = NotificationCenter.default
        let mainQueue = OperationQueue.main
        let observer = nc.addObserver(forName: ArtworkServiceNotification.name, object: nil, queue: mainQueue) { (notification) in
            guard
                let userInfo = notification.userInfo,
                let albumId = userInfo[ArtworkServiceNotification.albumIdKey] as? String,
                let image = userInfo[ArtworkServiceNotification.imageKey] as? UIImage,
                let albumIndex = self.albumFeed?.results.firstIndex(where: {$0.id == albumId})
                else {
                    return
            }
            self.delegate?.albumListModelController(self, didReceiveImage: image, forAlbumAt: Int(albumIndex))
        }
        self.albumArtworkObserver = observer
    }
    
    func removeNotificationObservers() {
        if let observer = self.albumArtworkObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }
}
