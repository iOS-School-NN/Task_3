import UIKit

protocol CharacterDetailPresenterProtocol: AnyObject {
    func toCharactersList()
}

// Данный класс представляет собой презентор, который ответственнен за бизнес-логику модуля "Подробнее о персонаже"
final class CharacterDetailPresenter: CharacterDetailPresenterProtocol {

    private weak var view: CharacterDetailViewProtocol!
    private let moduleRouter: ModuleRouterProtocol
    private let networkService: NetworkServiceProtocol

    private var character: Character

    init(character: Character, view: CharacterDetailViewProtocol, moduleRouter: ModuleRouterProtocol, networkService: NetworkServiceProtocol) {
        self.view = view
        self.moduleRouter = moduleRouter
        self.character = character
        self.networkService = networkService

        // Передача основной информации о выбранном персонаже во вью
        view.setInformation(imageData: character.imageData, name: character.name, gender: character.gender, status: character.status, species: character.species)
        
        loadLocation()
        loadEpisodes()
    }

    // Загрузка информации о локации из сети и её передача во вью
    private func loadLocation() {
        networkService.fetchLocation(urlString: character.location.url) { [weak self] location in
            self?.character.location.name = location?.name
            self?.character.location.type = location?.type

            self?.view.setLocation(name: self?.character.location.name ?? "unnamed", type: self?.character.location.type ?? "No type")
        }
    }

    // Загрузка информации о всех эпизодах из сети и её передача во вью
    private func loadEpisodes() {
        character.episodesURLs.forEach { URL in
            networkService.fetchEpisode(urlString: URL) { [weak self] episode in
                guard let episode = episode else {
                    return
                }

                self?.character.episodes?.append(episode)
                self?.view.setEpisode(episode: episode.episode, name: episode.name, airDate: episode.airDate)
            }
        }
    }

    // Возврат к списку персонажей
    func toCharactersList() {
        moduleRouter.pop()
        }
    }
