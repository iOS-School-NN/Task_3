//
//  DetailViewController.swift
//  Task_3
//
//  Created by KirRealDev on 11.07.2021.
//

import UIKit

class DetailViewController: UIViewController, MainViewControllerDelegate, DetailViewModelDelegate {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet private weak var detailCharacterImageView: UIImageView!
    
    @IBOutlet private weak var detailCharacterNameLabel: UILabel!
    @IBOutlet private weak var detailCharacterGenderLabel: UILabel!
    @IBOutlet private weak var detailCharacterStatusLabel: UILabel!
    @IBOutlet private weak var detailCharacterTypeLabel: UILabel!
    
    @IBOutlet weak var detailLocationTitleLabel: UILabel!
    @IBOutlet private weak var detailCharacterLocationNameLabel: UILabel!
    @IBOutlet private weak var detailCharacterLocationTypeLabel: UILabel!
    
    @IBOutlet weak var detailEpisodesTitleLabel: UILabel!
    @IBOutlet private weak var detailDescriptionOfEpisodesTextView: UITextView!
    
    //private var id: Int = 0
    var detailViewModel: DetailViewModel?
    var characterCardData: Result?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "character name"
        preLoading()
        //setIBOutlets()
    }
    
    func initCharacterCard(_ id: Int) {
        self.detailViewModel = DetailViewModel(characterId: id)
        self.detailViewModel?.delegate = self
        print("INIT")
        self.detailViewModel?.loadDetailInformation()
    }
    
    private func preLoading() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        detailCharacterNameLabel.text = ""
        detailCharacterGenderLabel.text = ""
        detailCharacterStatusLabel.text = ""
        detailCharacterTypeLabel.text = ""
        
        detailLocationTitleLabel.text = ""
        detailCharacterLocationNameLabel.text = ""
        detailCharacterLocationTypeLabel.text = ""
        
        detailEpisodesTitleLabel.text = ""
        detailDescriptionOfEpisodesTextView.isSelectable = false
        detailDescriptionOfEpisodesTextView.text = ""
    }
    
//    func setIBOutlets(characterCard: CharacterCardModel, characterLocation: CharacterLocationModel, characterEpisodes: CharactersEpisodesModel) {
//        guard let checkedData = characterCardData  else {
//            return
//        }
//        //detailCharacterImageView
//        self.navigationItem.title = checkedData.name
//        detailCharacterNameLabel.text = "Name: " + checkedData.name
//        detailCharacterGenderLabel.text = "Gender: " + checkedData.gender.rawValue
//        detailCharacterStatusLabel.text = "Status: " + checkedData.status.rawValue
//        detailCharacterTypeLabel.text = "Type: " + checkedData.type
//
//        detailLocationTitleLabel.text = "Location: "
//        detailCharacterLocationNameLabel.text = "Name: "
//        detailCharacterLocationTypeLabel.text = "Type: "
//
//        detailEpisodesTitleLabel.text = "Episodes: "
//        detailDescriptionOfEpisodesTextView.isSelectable = false
//        detailDescriptionOfEpisodesTextView.text = "bla-bla-bla..."
//    }
    
    func updateDetailViewBy(characterCard: CharacterCardModel, characterLocation: CharacterLocationModel, characterEpisodes: CharactersEpisodesModel) {
        detailCharacterImageView.image = UIImage(named: characterCard.image)
        self.navigationItem.title = characterCard.name
        detailCharacterNameLabel.text = "Name: " + characterCard.name
        detailCharacterGenderLabel.text = "Gender: " + characterCard.gender
        detailCharacterStatusLabel.text = "Status: " + characterCard.status
        detailCharacterTypeLabel.text = "Type: " + characterCard.type
        
        detailLocationTitleLabel.text = "Location: "
        detailCharacterLocationNameLabel.text = "Name: "
        detailCharacterLocationTypeLabel.text = "Type: "
        
        detailEpisodesTitleLabel.text = "Episodes: "
        detailDescriptionOfEpisodesTextView.isSelectable = false
        detailDescriptionOfEpisodesTextView.text = "bla-bla-bla..."
        
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }


}
