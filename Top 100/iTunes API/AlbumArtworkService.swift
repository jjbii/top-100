//
//  AlbumArtworkService.swift
//  Top 100
//
//  Created by Jack Bransfield on 7/11/20.
//  Copyright © 2020 Built Light. All rights reserved.
//

import UIKit

/// This class is responsible for providing album artwork images, by either fetching them for
/// a local cache, or by requesting them over the web.
///
/// It is implemented as a singleton for two reasons:
/// 1. It owns and maintains a cache that contains all successfullly fetched images.
/// 2. By keeping track of active network requests, it ensures that duplicate requests are never sent for the same resource.
class AlbumArtworkService: NSObject {
    
    // MARK: - Properties
    
    static let shared: AlbumArtworkService = AlbumArtworkService()
    private var cache = NSCache<NSString, UIImage>()
    private let session = URLSession.shared
    /// This dictionary is used to track any requests that are currently in flight.
    /// This prevents the app from sending multiple requests for the same resource.
    private var activeDataTasks = [String: URLSessionDataTask]()

    // MARK: - Initialization
    
    // Making the initialzer private ensures that it will only be instantiated as a singleton.
    private override init() {
        super.init()
    }
    
    // MARK: - Public
    
    /// If the desired image already exists in the cache, we return it immediately.
    /// Otherwise, we return `nil` and request the image from the web asynchronously.
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
        guard !self.requestInProgress(for: album) else { return }
                
        let request = URLRequest(url: album.artworkUrl)
        let task = self.session.dataTask(with: request) { (data, response, error) in
            defer {
                self.activeDataTasks[album.id] = nil
            }
            
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
    
    /// Because there may be multiple objects interested in receiving images fetched by
    /// this class, we post a notificaton rather than using a delegate protocol.
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
