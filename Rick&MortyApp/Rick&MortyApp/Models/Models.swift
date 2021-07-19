//
//  Models.swift
//  Rick&MortyApp
//
//  Created by Alexander on 14.07.2021.
//

import Foundation

struct PageInfo {
    let next: String?
    let prev: String?
}

struct Character {
    let identifier: Int
    let name: String
    let gender: String
    let status: String
    let species: String
    let imageUrl: String
    let locationUrl: String
    let episodesUrls: [String]
}

struct Location {
    let name: String
    let type: String
}

struct Episode {
    let identifier: Int
    let name: String
    let code: String
    let date: String
}
