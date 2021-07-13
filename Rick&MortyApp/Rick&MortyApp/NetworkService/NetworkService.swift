//
//  NetworkService.swift
//  Rick&MortyApp
//
//  Created by Alexander on 13.07.2021.
//

import Foundation

protocol NetworkService: AnyObject {
    func getCharacters(completion: @escaping (Result<[Character], ErrorMessage>) -> Void)
    func getEpisode(url: String, completion: @escaping (Result<Episode, ErrorMessage>) -> Void)
    func getLocation(url: String, completion: @escaping (Result<Location, ErrorMessage>) -> Void)
}

class NetworkServiceImpl: NetworkService {
    func getCharacters(completion: @escaping (Result<[Character], ErrorMessage>) -> Void) {
        NetworkPerformer.performRequest(url: "https://rickandmortyapi.com/api/character") { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let data):
                do {
                    let parseResult = try CharacterParser.parseCharactersList(data)
                    completion(.success(parseResult))
                } catch {
                    completion(.failure(.invalidParsing))
                }
            }
        }
    }
    
    func getEpisode(url: String, completion: @escaping (Result<Episode, ErrorMessage>) -> Void) {
        NetworkPerformer.performRequest(url: url) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let data):
                do {
                    let parseResult = try CharacterParser.parseEpisode(data)
                    completion(.success(parseResult))
                } catch {
                    completion(.failure(.invalidParsing))
                }
            }
        }
    }
    
    func getLocation(url: String, completion: @escaping (Result<Location, ErrorMessage>) -> Void) {
        NetworkPerformer.performRequest(url: url) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let data):
                do {
                    let parseResult = try CharacterParser.parseLocation(data)
                    completion(.success(parseResult))
                } catch {
                    completion(.failure(.invalidParsing))
                }
            }
        }
    }
}
