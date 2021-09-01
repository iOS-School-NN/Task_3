import UIKit

protocol CharactersListPresenterProtocol: AnyObject {
    var characters: [Character] { get }
    func fetchNewPage()
    func toCharacterDetails(id: Int)
    func fetchImage(urlString: String, completion: @escaping (Data?) -> Void)
}

// Данный класс представляет собой презентер, который ответственнен за бизнес-логику модуля "Список персонажей"
final class CharactersListPresenter: CharactersListPresenterProtocol {

    private weak var view: CharactersListViewProtocol!
    private let moduleRouter: ModuleRouterProtocol
    private let networkService: NetworkServiceProtocol

    var characters: [Character] = [] {
        didSet {
            view.updateCharacterList()
        }
    }

    private var nextPageURL: String? = "https://rickandmortyapi.com/api/character?page=1"
    private var isPaginating = false

    init(view: CharactersListViewProtocol, moduleRouter: ModuleRouterProtocol, networkService: NetworkServiceProtocol) {
        self.view = view
        self.moduleRouter = moduleRouter
        self.networkService = networkService
    }

    // Метод ответственный за загрузку новых страниц списка персонажей при прокрутке списка
    func fetchNewPage() {

        guard !isPaginating, let nextPageURL = nextPageURL else {
            print("already Paginating")
            return
        }

        isPaginating = true

        networkService.fetchPage(urlString: nextPageURL) { [weak self] page in
            print(nextPageURL)
            self?.nextPageURL = page?.info.next
            self?.characters += page?.results ?? []
            self?.isPaginating = false
        }

    }

    // Переход к модулю конкретного персонажа
    func toCharacterDetails(id: Int) {
        moduleRouter.toCharacterDetailModule(character: characters[id])
        print(characters[id].name)
    }

    // Метод-обертка для получения изображения персонажа для ячейки таблицы
    func fetchImage(urlString: String, completion: @escaping (Data?) -> Void) {
        networkService.fetchImage(urlString: urlString, completion: completion)
    }

}
