//
//  DetailViewController.swift
//  Task_3
//
//  Created by KirRealDev on 11.07.2021.
//

import UIKit

class DetailViewController: UIViewController, MainViewControllerDelegate {
    
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
    
    //var viewModel: DetailViewModel
    var characterCardData: Result?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "character name"
        loading()
        //setIBOutlets()
    }
    
    func initCharacterCard(_ item: Result) {
        characterCardData = item
    }
    
    private func loading() {
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
    
    private func setIBOutlets() {
        guard let checkedData = characterCardData  else {
            return
        }
        //detailCharacterImageView
        self.navigationItem.title = checkedData.name
        detailCharacterNameLabel.text = "Name: " + checkedData.name
        detailCharacterGenderLabel.text = "Gender: " + checkedData.gender.rawValue
        detailCharacterStatusLabel.text = "Status: " + checkedData.status.rawValue
        detailCharacterTypeLabel.text = "Type: " + checkedData.type
        
        detailLocationTitleLabel.text = "Location: "
        detailCharacterLocationNameLabel.text = "Name: "
        detailCharacterLocationTypeLabel.text = "Type: "
        
        detailEpisodesTitleLabel.text = "Episodes: "
        detailDescriptionOfEpisodesTextView.isSelectable = false
        detailDescriptionOfEpisodesTextView.text = "bla-bla-bla..."
    }


}
