//
//  DetailViewModel.swift
//  Task_3
//
//  Created by KirRealDev on 15.07.2021.
//

import Foundation

protocol DetailViewModelDelegate: AnyObject {
    func updateDetailViewBy(characterCard: CharacterCardModel, characterLocation: CharacterLocationModel, characterEpisodes: CharactersEpisodesModel)
}

final class DetailViewModel {
    var id: Int
    var characterCard: CharacterLocationModel?
    var characterLocation: CharacterLocationModel?
    var characterEpisodes: CharactersEpisodesModel?
    
    weak var delegate: DetailViewModelDelegate?
    
    let dispatchGroup = DispatchGroup()
    let queueForLoadAdditionalPages = DispatchQueue(
        label: "com.task_3.queueForLoadDetailInformation",
        attributes: [.concurrent, .initiallyInactive]
    )
    
    
    init(characterId: Int) {
        self.id = characterId
    }
    
    func loadDetailInformation() {
        print("I'm Load")
        DispatchQueue.global(qos: .userInitiated).async {
            self.loadCharacterCard(urlString: NetworkConstants.urlForLoadingListOfCharacters + "/\(self.id)")
        }
        
    }
    
    func loadCharacterCard(urlString: String) {
        dispatchGroup.enter()
        NetworkService.performGetRequestForLoadingCharacterCard(url: urlString, onComplete: { [weak self] (data) in
            self?.dispatchGroup.leave()
            self?.loadCharacterLocation(urlString: data.location.url)
//            self?.loadCharacterEpisodes(urlString: data.episode)
                
        }) { (error) in
                NSLog(error.localizedDescription)
                print("HELLO")
           }
    }
    
    func loadCharacterLocation(urlString: String) {
        dispatchGroup.enter()
        NetworkService.performGetRequestForLoadingCharacterCard(url: urlString, onComplete: { [weak self] (data) in
            print("location")
            self?.dispatchGroup.leave()
                
        }) { (error) in
                NSLog(error.localizedDescription)
                print("HELLO")
           }
    }
    
    func loadCharacterEpisodes(urlString: String) {
        dispatchGroup.enter()
        NetworkService.performGetRequestForLoadingCharacterCard(url: urlString, onComplete: { [weak self] (data) in
            self?.dispatchGroup.leave()
            print("episodes")
            //self?.characterCard = characterCard
                //self?.delegate?.updateDetailViewBy(item: data.results)
                //self?.asyncDownloadCharactersInfoByPage(count: data.info.pages, with: 3)
                
        }) { (error) in
                NSLog(error.localizedDescription)
                print("HELLO")
           }
    }
}
