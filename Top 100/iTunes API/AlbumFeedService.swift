//
//  AlbumFeedService.swift
//  Top 100
//
//  Created by Jack Bransfield on 7/10/20.
//  Copyright © 2020 Built Light. All rights reserved.
//

import Foundation

typealias AlbumFeedResult = Result<AlbumFeed, Error>

struct AlbumFeedService {
    
    // MARK: - Properties
    
    private let session = URLSession.shared
    
    private var feedRequest: URLRequest? {
        guard let url = URL(string: "https://rss.itunes.apple.com/api/v1/us/apple-music/top-albums/all/100/explicit.json") else {
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
    
    private var decoder: JSONDecoder {
        let dateFormatter = DateFormatter.iTunesDateFormatter
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        return decoder
    }
    
    // MARK: - Public
    
    func getAlbumFeed(completion: @escaping (AlbumFeedResult) -> Void) {
        guard let request = self.feedRequest else {
            completion(.failure(APIError.requestInitializationFailed))
            return
        }
        
        let task = self.session.dataTask(with: request) { (data, response, error) in
            // By calling the completion handler only once in the defer block,we guarantee it will be called
            // on the main queue without littering the code with calls to `DispatchQueue.main.async()`.
            let result: AlbumFeedResult
            defer {
                DispatchQueue.main.async {
                    completion(result)
                }
            }
            
            if let error = error {
                result = .failure(error)
                return
            }
            
            guard let data = data else {
                result = .failure(APIError.noResponseData)
                return
            }
            
            do {
                let albumFeed = try self.decoder.decode(AlbumFeed.self, from: data)
                result = .success(albumFeed)
            } catch let error {
                result = .failure(error)
            }
        }
        task.resume()
    }
}

enum APIError: Error {
    case noResponseData
    case requestInitializationFailed
    
    var localizedDescription: String {
        switch self {
        case .noResponseData:
            return "Response data is nil."
        case .requestInitializationFailed:
            return "The URLRequest could not be initialized."
        }
    }
}
