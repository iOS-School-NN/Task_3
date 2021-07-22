//
//  NetworkService.swift
//  Task_3
//
//  Created by KirRealDev on 11.07.2021.
//

import UIKit

private enum ServerError: Error {
    
    case noDataProvided
    case failedToDecode
}

struct NetworkConstants {
    static let urlForLoadingListOfCharacters = "https://rickandmortyapi.com/api/character"
}

struct NetworkService {
    
    static func makeGetRequest(urlString: String) -> URLRequest? {
        guard let url = URL(string: urlString) else {
            return nil
        }
        let request = URLRequest(url: url)
        
        return request
    }

    static func performGetRequest(url: String, pageId: Int, onComplete: @escaping (CharacterСardModel, Int) -> Void, onError: @escaping (Error, Int) -> Void) {
        
        guard let request = makeGetRequest(urlString: url) else {
            return
        }
        print(request)
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                onError(error, pageId)
                return
            }
            guard let  data = data else {
                onError(ServerError.noDataProvided, pageId)
                return
            }
            guard let info = try? JSONDecoder().decode(CharacterСardModel.self, from: data) else {
                NSLog("Could not decode")
                onError(ServerError.failedToDecode, pageId)
                return
            }
            
            DispatchQueue.main.async {
                onComplete(info, pageId)
            }
                
        }
        
        task.resume()
    }
    
    static func performGetConcurrentRequest(url: String, id: Int, onComplete: @escaping (CharacterСardModel, Int) -> Void, onError: @escaping (Error) -> Void) {
        
        guard let request = makeGetRequest(urlString: url) else {
            return
        }
        print(request)
        
        let session = URLSession.shared
        
        let defaultGlobal = DispatchQueue.global()
        //loadCharacterInformation(urlString: "https://rickandmortyapi.com/api/character?page=" + String(i))

        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                onError(error)
                return
            }
            guard let  data = data else {
                onError(ServerError.noDataProvided)
                return
            }
            guard let info = try? JSONDecoder().decode(CharacterСardModel.self, from: data) else {
                NSLog("Could not decode")
                onError(ServerError.failedToDecode)
                return
            }
            
            defaultGlobal.async {
                onComplete(info, id)
            }
                
        }
        
        task.resume()
    }

}
