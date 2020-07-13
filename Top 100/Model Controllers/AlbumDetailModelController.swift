//
//  AlbumDetailModelController.swift
//  Top 100
//
//  Created by Jack Bransfield on 7/12/20.
//  Copyright © 2020 Built Light. All rights reserved.
//

import UIKit

protocol AlbumDetailModelControllerDelegate: class {
    func albumDetailModelController(_ controller: AlbumDetailModelController, didReceiveImage image: UIImage)
}

class AlbumDetailModelController {
    
    // MARK: - Properties

    weak var delegate: AlbumDetailModelControllerDelegate?
    
    private let album: Album
    private let rank: Int
    private let artworkService = AlbumArtworkService.shared
    private var albumArtworkObserver: NSObjectProtocol?

    // MARK: - Initialization

    init(album: Album, rank: Int) {
        self.album = album
        self.rank = rank
        self.addNotificationObservers()
    }
    
    deinit {
        self.removeNotificationObservers()
    }
    
    // MARK: - Public
    
    var albumRank: String {
        return String(self.rank)
    }
    
    var albumName: String {
        return self.album.name
    }
    
    var artistName: String {
        return self.album.artistName
    }
    
    var genres: String {
        let names = self.album.genres.map { $0.name }
        let genres: String = names.joined(separator: ", ")
        return genres
    }
    
    var releaseDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter.string(from: self.album.releaseDate)
    }
    
    var artwork: UIImage? {
        return self.artworkService.artwork(for: self.album)
    }
    
    var copyrightInfo: String {
        return self.album.copyright
    }
    
    var appleMusicUrl: URL {
        return self.album.url
    }
}

// MARK: - Private

private extension AlbumDetailModelController {
    
    func addNotificationObservers() {
        let nc = NotificationCenter.default
        let mainQueue = OperationQueue.main
        let observer = nc.addObserver(forName: ArtworkServiceNotification.name, object: nil, queue: mainQueue) { (notification) in
            guard
                let userInfo = notification.userInfo,
                let albumId = userInfo[ArtworkServiceNotification.albumIdKey] as? String,
                albumId == self.album.id,
                let image = userInfo[ArtworkServiceNotification.imageKey] as? UIImage
                else {
                    return
            }
            self.delegate?.albumDetailModelController(self, didReceiveImage: image)
        }
        self.albumArtworkObserver = observer
    }
    
    func removeNotificationObservers() {
        if let observer = self.albumArtworkObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }
}
