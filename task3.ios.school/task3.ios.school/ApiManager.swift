//
//  ApiManager.swift
//  task3.ios.school
//
//  Created by XO on 18.07.2021.
//  Copyright © 2021 XO. All rights reserved.
//

import Foundation

enum RickError: Error {
    case network
}

class ApiManager {
    static let shared = ApiManager()
    
    var baseURL = URL(string: "https://rickandmortyapi.com/api/character")!
    let baseURL2 = URL(string: "https://rickandmortyapi.com/api/character/?page=2")!
    
    
    func getCharacters(completion: @escaping (Result<[Character], RickError>) -> Void) {
        var request = URLRequest(url: baseURL2, cachePolicy: .reloadRevalidatingCacheData)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                completion(.failure(.network))
                return
            }
            if let data = data, let characters = try? JSONDecoder().decode(CharatersResults.self, from: data) {
                completion(.success(characters.results))
            } else {
                completion(.failure(.network))
            }
        }
        task.resume()
        
    }
    
    
    func getCharacters1(completion: @escaping (Result<[Character], RickError>) -> Void) {
        var request = URLRequest(url: baseURL)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                completion(.failure(.network))
                return
            }
            if let data = data, let characters = try? JSONDecoder().decode(CharatersResults.self, from: data) {
                completion(.success(characters.results))
            } else {
                completion(.failure(.network))
            }
        }
        task.resume()
        
    }
    
}
