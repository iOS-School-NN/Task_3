import UIKit

protocol ModuleBuilderProtocol {
    func buildCharactersListModule(moduleRouter: ModuleRouterProtocol, networkService: NetworkServiceProtocol) -> UIViewController
    func buildCharacterDetailModule(character: Character, moduleRouter: ModuleRouterProtocol, networkService: NetworkServiceProtocol) -> UIViewController
}

// Класс отвечающий за сборку модулей (вью) в приложении
final class ModuleBuilder: ModuleBuilderProtocol {

    // Сборка модуля со списком персонажей
    func buildCharactersListModule(moduleRouter: ModuleRouterProtocol, networkService: NetworkServiceProtocol) -> UIViewController {
        let view = CharactersListView()
        view.presenter = CharactersListPresenter(view: view, moduleRouter: moduleRouter, networkService: networkService)
        return view
    }

    // Сборка модуля конкретного персонажа
    func buildCharacterDetailModule(character: Character, moduleRouter: ModuleRouterProtocol, networkService: NetworkServiceProtocol) -> UIViewController {
        let view = CharacterDetailView()
        view.presenter = CharacterDetailPresenter(character: character, view: view, moduleRouter: moduleRouter, networkService: networkService)
        return view
    }
}
