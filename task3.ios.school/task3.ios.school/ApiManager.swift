//
//  ApiManager.swift
//  task3.ios.school
//
//  Created by XO on 18.07.2021.
//  Copyright © 2021 XO. All rights reserved.
//

import Foundation
import UIKit

enum RickError: Error {
    case network
}

class ApiManager {
    
    private let decoder = JSONDecoder()
    private let queueConcurrent = DispatchQueue(label: "ConcurrentQueue", qos: .background, attributes: .concurrent)
    private let group = DispatchGroup()
    private let groupTwo = DispatchGroup()
    private let queueFirst = DispatchQueue.global(qos: .userInitiated)
    
    func getCharactersFromFirstPage(completion: @escaping (Result<[Character], RickError>) -> Void) {
        let baseURL = URL(string: "https://rickandmortyapi.com/api/character")!
        var request = URLRequest(url: baseURL, cachePolicy: .reloadRevalidatingCacheData)
        request.httpMethod = "GET"
        queueFirst.async {
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                completion(.failure(.network))
                return
            }
            if let data = data, let characters = try? self.decoder.decode(CharatersResponse.self, from: data) {
                completion(.success(characters.results))
                print("x")
            } else {
                completion(.failure(.network))
            }
        }
        task.resume()
        }
    }
    
    func getCharactersTwoToLastPage(numberOfPages: Int, completion: @escaping (Result<[Character], RickError>) -> Void) {
        let numberOfIterations = (numberOfPages - 1)/3
        for i in 0..<numberOfIterations {
            queueConcurrent.sync {
                let url = URL(string: "https://rickandmortyapi.com/api/character/?page=\(2+(i*3))")
                var request = URLRequest(url: url!)
                request.httpMethod = "GET"
                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    if let error = error {
                        print(error.localizedDescription)
                        completion(.failure(.network))
                        return
                    }
                    if let data = data, let characters = try? self.decoder.decode(CharatersResponse.self, from: data) {
                        completion(.success(characters.results))
                        print(1)
                    } else {
                        completion(.failure(.network))
                    }
                }
                task.resume()
            }
            
            queueConcurrent.sync {
                let url = URL(string: "https://rickandmortyapi.com/api/character/?page=\(3+(i*3))")
                var request = URLRequest(url: url!)
                request.httpMethod = "GET"
                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    if let error = error {
                        print(error.localizedDescription)
                        completion(.failure(.network))
                        return
                    }
                    if let data = data, let characters = try? self.decoder.decode(CharatersResponse.self, from: data) {
                        completion(.success(characters.results))
                        print(2)
                    } else {
                        completion(.failure(.network))
                    }
                }
                task.resume()
            }
            
            queueConcurrent.sync {
                let url = URL(string: "https://rickandmortyapi.com/api/character/?page=\(4+(i*3))")
                var request = URLRequest(url: url!)
                request.httpMethod = "GET"
                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    if let error = error {
                        print(error.localizedDescription)
                        completion(.failure(.network))
                        return
                    }
                    if let data = data, let characters = try? self.decoder.decode(CharatersResponse.self, from: data) {
                        completion(.success(characters.results))
                        print(3)
                    } else {
                        completion(.failure(.network))
                    }
                }
                task.resume()
            }

        }
        
    }
    
    func getImage(imageURL:(String)) -> UIImage {
        var imageU = UIImage() {
            didSet {
                DispatchQueue.main.async {
                    print(imageU)
                }
            }
        }
        let imageURL = URL(string: imageURL)!
        var request = URLRequest(url: imageURL)
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                    return
            }
            if let data = data, let image = UIImage(data: data) {
                imageU = image
            }
        }.resume()
        return imageU

    }
    
    func getLocation (locationURL: String, completion: @escaping (Result<Location, RickError>) -> Void) {
        guard let url = URL(string: locationURL) else { return }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(.failure(.network))
                return
            }
            if let data = data, let location = try? self.decoder.decode(Location.self, from: data) {
                completion(.success(location))
            } else {
                completion(.failure(.network))
            }
        }
        task.resume()
    }
    
    func getEpisodeFromURL (episodeURL: String, completion: @escaping (Result<Episode, RickError>) -> Void) {
        let url = URL(string: episodeURL)
        let request = URLRequest(url: url!)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                completion(.failure(.network))
                return
            }
            if let data = data, let episode = try? self.decoder.decode(Episode.self, from: data) {
                completion(.success(episode))
            } else {
                completion(.failure(.network))
            }
        }
        task.resume()
    }
       
    var episodesArray = [Episode]()
    var stringOfEpisodesWithDate = String()
    var queueForCharacters = DispatchQueue(label: "MyQueueee")
    var completionHandler: ( (_ stringOfEpisodesWithData: String) -> Void )?
    func getEpisodesForOneCharacter(character: Character, completion: @escaping (String) -> Void) {
            
            for i in 0..<character.episode.count {
                self.groupTwo.enter()
                
                self.getEpisodeFromURL(episodeURL: character.episode[i]) { result in
                    switch result {
                        case .failure(let error):
                            print(error.localizedDescription)
                        case .success(let episode):
                            self.episodesArray.append(episode)
                            self.groupTwo.leave()
                    }
                }
            }
        
            self.groupTwo.notify(queue: .main) {
                self.episodesArray = self.episodesArray.sorted { ($0.id<$1.id) }
                self.stringOfEpisodesWithDate = self.episodesArray.map({ "\($0.episode) / \($0.name) / \($0.air_date)" }).joined(separator: "\n")
                completion(self.stringOfEpisodesWithDate)
            }
        
    }
    
}
