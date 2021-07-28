//
//  Model.swift
//  task3.ios.school
//
//  Created by XO on 12.07.2021.
//  Copyright © 2021 XO. All rights reserved.
//

import Foundation
import UIKit
//

struct Character: Codable {
    let id: Int
    let name, status, species, type: String
    let gender: String
    let origin, location: CharacterLocation
    let image: String
    let episode: [String]
    let url: String
    let created: String
}

struct CharacterLocation: Codable {
    let name: String
    let url: String
}

struct CharatersResponse: Codable {
    let info: Info
    let results: [Character]
}

struct Info: Codable {
    let count: Int
    let pages: Int
    let next: String?
    let prev: String?
}

struct EpisodeResponse: Codable {
    let info: Info
    let results: Episode
}

struct Episode: Codable {
    let id: Int
    let name: String
    let air_date: String
    let episode: String
    let characters: [String]
    let url: String
    let created: String
}

struct LocationResponse: Codable {
    let info: Info
    let results: Location
}

struct Location: Codable {
    let id: Int
    let name: String
    let type: String
    let dimension: String
    let residents: [String]
    let url: String
    let created: String
    
}

struct customizedCharacterResult {
    let character: Character?
    let image: UIImage?
}

typealias Characters = [Character]
//
//
//
//let baseURL = URL(fileURLWithPath: "https://rickandmortyapi.com/api")
//var request = URLRequest(url: baseURL)
//
//enum RickError: Error {
//    case network
//}
//
//var sem = DispatchSemaphore(value: 0)
//
//class ApiManager {
//    static let shared = ApiManager()
//
//    func getUsers(completion: @escaping (Result<[Character]>, RickError) -> Void) {
//        var request = URLRequest(url: baseURL)
//        request.httpMethod = "GET"
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                print (error.localizedDescription)
//                completion(.failure(.network))
//            }
//            if let data = data, let characters = try? JSONDecoder().decode(Character.self, from: data) {
//                completion(.success(characters.results))
//            } else {
//                completion(.failure(.network))
//            }
//        }
//        task.resume()
//        print(Characters.self)
//    }
//}
//
//ApiManager.shared.getUsers { result in
//    switch result {
//    case .failure(let error) :
//        print(error)
//    
//    case .succsess(let characters):
//        print(characters)
//    }
//}
