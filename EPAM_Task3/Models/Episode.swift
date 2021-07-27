import Foundation

// Структура содержит информацию об эпизоде мультсериала "Рик и Морти"
struct Episode: Decodable {
    let name: String
    let airDate: String
    let episode: String

    private enum CodingKeys: String, CodingKey {
        case name
        case airDate = "air_date"
        case episode
    }
}
