//
//  Model.swift
//  task3.ios.school
//
//  Created by XO on 12.07.2021.
//  Copyright © 2021 XO. All rights reserved.
//

import Foundation
//

struct Character: Codable {
    let id: Int
    let name, status, species, type: String
    let gender: String
    let origin, location: Location
    let image: String
    let episode: [String]
    let url: String
    let created: String
}

struct Location: Codable {
    let name: String
    let url: String
}

struct CharatersResults: Codable {
    let info: infos
    let results: [Character]
}

struct infos: Codable {
    let count: Int
    let pages: Int
    let next: String?
    let prev: String?
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
