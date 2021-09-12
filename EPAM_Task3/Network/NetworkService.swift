import UIKit

protocol NetworkServiceProtocol {
    func fetchData(urlString: String, completion: @escaping (Data?) -> Void)
    func fetchPage(urlString: String, completion: @escaping (Page?) -> Void)
    func fetchCharacter(urlString: String, completion: @escaping (Character?) -> Void)
    func fetchEpisode(urlString: String, completion: @escaping (Episode?) -> Void)
    func fetchLocation(urlString: String, completion: @escaping (Location?) -> Void)
    func fetchImage(urlString: String, completion: @escaping (Data?) -> Void)
}

// Класс ответственный за получение и декодирование данных из сети интернет
// В данном приложении используется для получения данных из API https://rickandmortyapi.com
final class NetworkService: NetworkServiceProtocol {

    // Кэш для хранения изображений в Data
    let imageDataCache = NSCache<AnyObject, AnyObject>()
    
    // Построение запроса данных по URL
    private func request(urlString: String, completion: @escaping (Data?, Error?) -> Void) {
        guard let url = URL(string: urlString) else { return }
        let request = URLRequest(url: url)
        let task = createDataTask(from: request, completion: completion)
        task.resume()
    }

    // Метод ответсвтенный за создание DataTask
    private func createDataTask(from requst: URLRequest, completion: @escaping (Data?, Error?) -> Void) -> URLSessionDataTask {
        return URLSession.shared.dataTask(with: requst, completionHandler: { (data, _, error) in
            DispatchQueue.main.async {
                completion(data, error)
            }
        })
    }

    // Получение данных в JSON формате и преобразование их в любую модель данных через универсальный шаблон
    func fetchJSONData<T: Decodable>(urlString: String, response: @escaping (T?) -> Void) {
        request(urlString: urlString) { (data, error) in
            if let error = error {
                print("Error received requesting data: \(error.localizedDescription)")
                response(nil)
            }

            let decoded = self.decodeJSON(type: T.self, from: data)
            response(decoded)

        }
    }

    // Парсинг данных (Data) в любую модель данных через универсальные шаблоны
    private func decodeJSON<T: Decodable>(type: T.Type, from: Data?) -> T? {
        let decoder = JSONDecoder()
        guard let data = from else { return nil }
        do {
            let objects = try decoder.decode(type.self, from: data)

            return objects
        } catch let jsonError {
            print("Failed to decode JSON", jsonError)
            return nil
        }
    }

    // Получение данных из сети в формате Data
    func fetchData(urlString: String, completion: @escaping (Data?) -> Void) {
        request(urlString: urlString) { (data, error) in
            if let error = error {
                print("Error received requesting data: \(error.localizedDescription)")
                completion(nil)
            }

            completion(data)
        }
    }

    // Получения страницы с персонажами вселенной мультсериала "Рик и Морти"
    func fetchPage(urlString: String, completion: @escaping (Page?) -> Void) {
        fetchJSONData(urlString: urlString, response: completion)
    }

    // Получение информации о персонаже вселенной мультсериала "Рик и Морти"
    func fetchCharacter(urlString: String, completion: @escaping (Character?) -> Void) {
        fetchJSONData(urlString: urlString, response: completion)
    }

    // Получение информации об эпизоде мультсериала "Рик и Морти"
    func fetchEpisode(urlString: String, completion: @escaping (Episode?) -> Void) {
        fetchJSONData(urlString: urlString, response: completion)
    }

    // Получение информации о локации из вселенной мультсериала "Рик и Морти"
    func fetchLocation(urlString: String, completion: @escaping (Location?) -> Void) {
        fetchJSONData(urlString: urlString, response: completion)
    }

    // Получение изображения из сети интернет или его получение из кеша
    func fetchImage(urlString: String, completion: @escaping (Data?) -> Void) {
        if let imageDataFromCache = imageDataCache.object(forKey: urlString as AnyObject) as? Data {
            completion(imageDataFromCache)
            return
        }

        fetchData(urlString: urlString) { [weak self] imageData in
            self?.imageDataCache.setObject(imageData as AnyObject, forKey: urlString as AnyObject)
            completion(imageData)
        }
    }
}
