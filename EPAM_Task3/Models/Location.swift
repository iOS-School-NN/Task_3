import Foundation

// Структура описывает локацию, в которой обитает определенный персонаж мультфильма "Рик и Морти"
struct Location: Decodable {
    let url: String
    var name: String?
    var type: String?
}
