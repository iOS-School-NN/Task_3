//
//  CharacterCardModel.swift
//  RickAndMortyApp
//
//  Created by Grifus on 10.07.2021.
//

import Foundation

struct Character: Codable {
    var results: [Result]
}

struct Result: Codable {
    let id: Int
    let name: String
    let image: String
}
