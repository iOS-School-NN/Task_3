import UIKit

// Структура отвечет за представление информации о персонаже внутри вселенной мультфильма "Рик и Морти"
class Character: Decodable {
    let name: String
    let status: String
    let species: String
    let imageURL: String
    let type: String
    let gender: String
    var episodesURLs: [String]
    var episodes: [Episode]?
    var location: Location
    var imageData: Data?

    private enum CodingKeys: String, CodingKey {
        case name
        case status
        case species
        case imageURL = "image"
        case type
        case gender
        case episodesURLs = "episode"
        case episodes
        case location
        case imageData
    }
}
