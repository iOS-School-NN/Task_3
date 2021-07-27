import UIKit

protocol ModuleRouterProtocol {
    func initViewController()
    func toCharacterDetailModule(character: Character)
    func popToRoot()
    func pop()
}

// Класс отвечающий за переход между модулями (вью) в приложении
final class ModuleRouter: ModuleRouterProtocol {
    private let navigationController: UINavigationController?
    private let moduleBuilder: ModuleBuilderProtocol?

    init(navigationController: UINavigationController, moduleBuilder: ModuleBuilderProtocol) {
        self.navigationController = navigationController
        self.moduleBuilder = moduleBuilder
    }

    // Инициализация модуля со списком персонажей как корневого
    func initViewController() {
        if let navigationController = navigationController {
            guard let module = moduleBuilder?.buildCharactersListModule(moduleRouter: self, networkService: NetworkService()) else {
                return
            }
            navigationController.viewControllers = [module]
        }
    }

    // Переход к модулю конкретного персонажа
    func toCharacterDetailModule(character: Character) {
        if let navigationController = navigationController {
            guard let module = moduleBuilder?.buildCharacterDetailModule(character: character, moduleRouter: self, networkService: NetworkService()) else {
                return
            }
            navigationController.pushViewController(module, animated: true)
        }
    }

    // Метод закрывающий все модули кроме корневого
    // Модули удаляются из стека navigationController и памяти
    func popToRoot() {
        if let navigationController = navigationController {
            navigationController.popToRootViewController(animated: true)
        }
    }

    // Метод закрывающий последний модуль (вью)
    // Модуль удаляется из стека navigationController и памяти
    func pop() {
        if let navigationController = navigationController {
            navigationController.popViewController(animated: true)
        }
    }
}
