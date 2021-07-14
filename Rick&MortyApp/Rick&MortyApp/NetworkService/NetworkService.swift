//
//  NetworkService.swift
//  Rick&MortyApp
//
//  Created by Alexander on 13.07.2021.
//

import Foundation

class NetworkService {
    private let performer = NetworkPerformer()
    private var imageCache = NSCache<NSString, AnyObject>()
    
    func getCharactersPage(url: String, completion: @escaping (Result<(PageInfo, [Character]), ErrorMessage>) -> Void) {
        performer.performRequest(url: url) {
            switch $0 {
            case .success(let data):
                do {
                    let parseResult = try CharacterParser.parseCharactersPage(data)
                    completion(.success(parseResult))
                } catch {
                    completion(.failure(.invalidParsing))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getEpisode(url: String, completion: @escaping (Result<Episode, ErrorMessage>) -> Void) {
        performer.performRequest(url: url) {
            switch $0 {
            case .success(let data):
                do {
                    let parseResult = try CharacterParser.parseEpisode(data)
                    completion(.success(parseResult))
                } catch {
                    completion(.failure(.invalidParsing))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getEpisodes(urls: [String], completion: @escaping (Result<[Episode], ErrorMessage>) -> Void) {
        let group = DispatchGroup()
        let queue = DispatchQueue.global(qos: .background)
        var episodes = [Episode]()
        
        urls.forEach { url in
            group.enter()
            queue.async {
                self.getEpisode(url: url) {
                    switch $0 {
                    case .success(let episode):
                        episodes.append(episode)
                        group.leave()
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }
        }
        group.notify(queue: queue) {
            completion(.success(episodes.sorted { $0.identifier < $1.identifier }))
        }
    }
    
    func getLocation(url: String, completion: @escaping (Result<Location, ErrorMessage>) -> Void) {
        performer.performRequest(url: url) {
            switch $0 {
            case .success(let data):
                do {
                    let parseResult = try CharacterParser.parseLocation(data)
                    completion(.success(parseResult))
                } catch {
                    completion(.failure(.invalidParsing))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func downloadImage(url: String, completion: @escaping (Result<Data, ErrorMessage>) -> Void) {
        guard let imageUrl = URL(string: url) else {
            completion(.failure(.invalidURL))
            return
        }
        
        if let imageData = imageCache.object(forKey: imageUrl.absoluteString as NSString) as? Data {
            completion(.success(imageData))
            return
        }
        
        performer.performRequest(url: url) {
            switch $0 {
            case .success(let imageData):
                completion(.success(imageData))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
