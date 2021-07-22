//
//  Episode.swift
//  Task3
//
//  Created by Mary Matichina on 11.07.2021.
//

import Foundation
import ObjectMapper

struct Episode: Mappable {
    
    var date = ""
    var name = ""
    var code = ""
    var url = ""
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        date <- map["air_date"]
        name <- map["name"]
        code <- map["episode"]
        url <- map["url"]
    }
}

extension Episode {
    
    var episodeString: String {
        return code + " /" + name  + " /" + date
    }
}
