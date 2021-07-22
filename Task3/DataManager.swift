//
//  DataManager.swift
//  Task3
//
//  Created by Mary Matichina on 11.07.2021.
//

import Foundation
import ObjectMapper

class DataManager {
    
    // MARK: - Configure
    
    static func getCharacterList(page: Int, completion: @escaping(Response) -> ()) {
        guard let url = URL(string: API.character + "/?page=\(page)") else { return }
        
        NetworkingService.shared.getData(url: url) { (json) in
            if let json = json as? [String: Any],
               let response = Mapper<Response>().map(JSON: json) {
                completion(response)
            }
        }
    }
    
    static func getCharacterId(id: Int, completion: @escaping(Character?) -> ()) {
        guard let url = URL(string: API.character + "/\(id)") else { return }
        
        NetworkingService.shared.getData(url: url) { (json) in
            if let json = json as? [String: Any],
               let response = Mapper<Character>().map(JSON: json) {
                completion(response)
            }
        }
    }
    
    static func getLocation(location: Location, completion: @escaping(Location?) -> ()) {
        guard let url = URL(string: location.url) else { return }
        
        NetworkingService.shared.getData(url: url) { (json) in
            if let json = json as? [String: Any],
               let response = Mapper<Location>().map(JSON: json) {
                completion(response)
            }
        }
    }
    
    static func getEpisode(url: String, completion: @escaping(Episode?) -> ()) {
        guard let url = URL(string: url) else { return }
        
        NetworkingService.shared.getData(url: url) { (json) in
            if let json = json as? [String: Any],
               let response = Mapper<Episode>().map(JSON: json) {
                completion(response)
            }
        }
    }
    
}
