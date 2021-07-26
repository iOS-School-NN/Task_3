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
    private let queueFirst = DispatchQueue.global(qos: .userInitiated)
    
    func getCustomCharactersFromFirstPage(character: [Character]) -> [customizedCharacterResult] {
        var CustomizdeCharacters = [customizedCharacterResult]()
        var image = UIImage()
        for i in character.startIndex...character.endIndex {
            
        
        image = getImage(imageURL: character[i].url)
        getCharactersFromFirstPage(completion: { result in
        switch result {
        case .failure(let error):
            print(error)
        case .success(let characters):
            let CustomChar = customizedCharacterResult(character: characters[i], image: image)
            CustomizdeCharacters.append(CustomChar)
            }
        })
        }
        return CustomizdeCharacters
    }
    
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
    
    
    func set(character: Character) -> UIImageView {
        let imageSource = character.image
        let characterImageView = UIImageView()
        if let url = URL(string: imageSource) {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print(error)
                } else {
                    if let data = data, let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            characterImageView.image = image
                        }
                    }
                }
                
            }
            task.resume()
        }
        return characterImageView
    }
    
}
