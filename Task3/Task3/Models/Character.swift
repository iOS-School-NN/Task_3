//
//  Model.swift
//  Task3
//
//  Created by Mary Matichina on 11.07.2021.
//

import Foundation
import ObjectMapper

struct Character: Mappable {
    
    var id: Int?
    var name = ""
    var status = ""
    var species = ""
    var type = ""
    var gender = ""
    var location: Location?
    var image = ""
    var episode: [String] = []

    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        status <- map["status"]
        species <- map["species"]
        type <- map["type"]
        gender <- map["gender"]
        location <- map["location"]
        image <- map["image"]
        episode <- map["episode"]
    }
}
