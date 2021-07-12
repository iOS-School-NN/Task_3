//
//  Character.swift
//  Rick&MortyApp
//
//  Created by Alexander on 12.07.2021.
//

import UIKit

struct Character {
    let name: String
    let gender: String
    let status: String
    let species: String
    let imageUrl: String
    let locationUrl: String
    let episodesUrls: [String]
    
    var image: UIImage? {
//        let url = URL(string: imageUrl)
//        let data = try? Data(contentsOf: url!)
//        return UIImage(data: data!)
        UIImage()
    }
}
