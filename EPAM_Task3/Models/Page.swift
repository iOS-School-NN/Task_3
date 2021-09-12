import Foundation

// Модель данных представляющая страницу со списком персонажей
struct Page: Decodable {
    let info: PageInfo
    let results: [Character]?
}

struct PageInfo: Decodable {
    let next: String?
    let prev: String?
}
