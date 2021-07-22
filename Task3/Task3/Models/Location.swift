//
//  Location.swift
//  Task3
//
//  Created by Mary Matichina on 11.07.2021.
//

import Foundation
import ObjectMapper

struct Location: Mappable {
    
    var name = ""
    var type = ""
    var url = ""

    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        name <- map["name"]
        type <- map["type"]
        url <- map["url"]
    }
}
