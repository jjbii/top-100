//
//  AlbumArtworkService.swift
//  Top 100
//
//  Created by Jack Bransfield on 7/11/20.
//  Copyright © 2020 Built Light. All rights reserved.
//

import UIKit

class AlbumArtworkService: NSObject {
    
    // MARK: - Properties
    
    static var shared: AlbumArtworkService = AlbumArtworkService()
    private var cache = NSCache<NSString, UIImage>()
    private let session = URLSession.shared
    private var activeRequestKeys = Set<String>()

    // MARK: - Initialization
    
    private override init() {
        super.init()
    }
    
    // MARK: - Public
    
    func artwork(for album: Album) -> UIImage? {
        if let cachedImage = self.cache.object(forKey: album.id as NSString) {
            return cachedImage
        } else {
            self.requestArtworkImage(for: album)
            return nil
        }
    }
}

// MARK: - Private

private extension AlbumArtworkService {
    
    func requestArtworkImage(for album: Album) {
        guard let artworkUrl = album.artworkUrl else {
            return
        }
        /// `inserted` will be true if the key was not already present in the set.
        /// This means a request is not currently in progress, so we are free to send one.
        let (inserted, _) = self.activeRequestKeys.insert(album.id)
        guard inserted else {
            return
        }
        
        let request = URLRequest(url: artworkUrl)
        
        let task = self.session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error fetching artwork for album with ID: \(album.id)\n\(error)")
                return
            }
            
            guard
                let data = data,
                let image = UIImage(data: data)
                else {
                    print("Error parsing image data for album with ID: \(album.id)")
                    return
            }
            
            self.cache.setObject(image, forKey: album.id as NSString)
            self.postNotification(forImage: image, withAlbumId: album.id)
            self.activeRequestKeys.remove(album.id)
        }
        task.resume()
    }
    
    func postNotification(forImage image: UIImage, withAlbumId albumId: String) {
        NotificationCenter.default.post(name: ArtworkServiceNotification.name,
                                        object: self,
                                        userInfo: [
                                            ArtworkServiceNotification.albumIdKey: albumId,
                                            ArtworkServiceNotification.imageKey: image
        ])
    }
}

struct ArtworkServiceNotification {
    static let name = Notification.Name(rawValue: "AlbumArtworkServiceDidReceiveImage")
    static let albumIdKey = "AlbumId"
    static let imageKey = "Image"
}
