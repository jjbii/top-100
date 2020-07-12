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
    private var activeDataTasks = [String: URLSessionDataTask]()

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
    
    func cancelPrefetchRequest(for album: Album) {
        if let task = self.activeDataTasks[album.id] {
            task.cancel()
            self.activeDataTasks[album.id] = nil
        }
    }
}

// MARK: - Private

private extension AlbumArtworkService {
    
    func requestArtworkImage(for album: Album) {
        guard
            let artworkUrl = album.artworkUrl,
            !self.requestInProgress(for: album)
            else {
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
            self.activeDataTasks[album.id] = nil
        }
        self.activeDataTasks[album.id] = task
        task.resume()
    }
    
    func requestInProgress(for album: Album) -> Bool {
        if let _ = self.activeDataTasks[album.id] {
            return true
        }
        return false
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
