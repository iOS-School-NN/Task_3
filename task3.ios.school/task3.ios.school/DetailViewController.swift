//
//  DetailViewController.swift
//  task3.ios.school
//
//  Created by XO on 13.07.2021.
//  Copyright © 2021 XO. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, Routerable {

    typealias Router = MainRouting
    var apiManager = ApiManager()
    
    
    let nameLabel = UILabel()
    let genderLabel = UILabel()
    let statusLabel = UILabel()
    let kindLabel = UILabel()
    var imageView = UIImageView(frame: .zero)
    let place = UILabel()
    let placeNameLabel = UILabel()
    let typePlaceNameLabel = UILabel()
    let episodes = UILabel()
    let episodesTextView = UITextView()
    
    var router: Router?
    var passedCharacter: Character?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = passedCharacter?.name
        eraseAllFields()
        view.addSubview(imageView)
        view.addSubview(nameLabel)
        view.addSubview(genderLabel)
        view.addSubview(statusLabel)
        view.addSubview(kindLabel)
        view.addSubview(place)
        view.addSubview(placeNameLabel)
        view.addSubview(typePlaceNameLabel)
        view.addSubview(episodes)
        view.addSubview(episodesTextView)
        customizeDetailVC(character: passedCharacter!)
    
        

        
        // Do any additional setup after loading the view.
    }
    
    func eraseAllFields() {
        imageView.image = nil
        nameLabel.text = ""
        genderLabel.text = ""
        statusLabel.text = ""
        kindLabel.text = ""
        place.text = ""
        placeNameLabel.text = ""
        typePlaceNameLabel.text = ""
        episodes.text = ""
        episodesTextView.text = ""
    }
    
    func customizeDetailVC(character: Character) {
        fillAllfields(character: character)
        customizeImageView()
        customizeNameLabel()
        customizeGenderLabel()
        customizeStatusLabel()
        customizeKindLabel()
        customizePlace()
        customizePlaceNameLabel()
        customizeTypePlaceNameLabel()
        customizeEpisode()
        customizeEpisodeTextView()
    }
    
    func fillAllfields(character: Character) {
        imageView.loadImageWithCache(from: character.image) { (data, url) in
            if character.image == url {
                DispatchQueue.main.async {
                    self.imageView.image = UIImage(data: data)
                }
            }
        }
        nameLabel.text = character.name
        genderLabel.text = character.gender
        statusLabel.text = character.status
        kindLabel.text = character.species
        place.text = "Location:"
        apiManager.getLocation(locationURL: character.location.url) { result in
            switch result {
            case.failure (let error):
                print(error)
                print(character.location.url)
            case.success (let location):
                DispatchQueue.main.async {
                self.placeNameLabel.text = "• " + location.name
                self.typePlaceNameLabel.text = "• " + location.type
                }
            }
        }
        episodes.text = "Episodes:"
        apiManager.getEpisodesForOneCharacter(character: character) { (textForView) in
            DispatchQueue.main.async {
                self.episodesTextView.text = textForView
            }
        }

    }
    
    func customizeImageView() {
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12).isActive = true
        imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 80).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor).isActive = true
    }
    
    func customizeNameLabel() {
        nameLabel.textAlignment = .left
        nameLabel.textColor = .white
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 10).isActive = true
        nameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 80).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
    }
    
    func customizeGenderLabel() {
        genderLabel.textAlignment = .left
        genderLabel.textColor = .white
        genderLabel.translatesAutoresizingMaskIntoConstraints = false
        genderLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 10).isActive = true
        genderLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 12).isActive = true
        genderLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
    }
    
    func customizeStatusLabel() {
        statusLabel.textAlignment = .left
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 10).isActive = true
        statusLabel.topAnchor.constraint(equalTo: genderLabel.bottomAnchor, constant: 12).isActive = true
        statusLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
    }
    
    func customizeKindLabel() {
           kindLabel.textAlignment = .left
           kindLabel.translatesAutoresizingMaskIntoConstraints = false
           kindLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 10).isActive = true
           kindLabel.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 12).isActive = true
           kindLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
       }
    
    func customizePlace() {
        place.textAlignment = .left
        place.textColor = UIColor.white
        place.translatesAutoresizingMaskIntoConstraints = false
        place.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12).isActive = true
        place.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10).isActive = true
        place.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
    }
    
    func customizePlaceNameLabel() {
        placeNameLabel.textAlignment = .left
        placeNameLabel.textColor = UIColor.white
        placeNameLabel.translatesAutoresizingMaskIntoConstraints = false
        placeNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        placeNameLabel.topAnchor.constraint(equalTo: place.bottomAnchor, constant: 10).isActive = true
        placeNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
    }
    
    func customizeTypePlaceNameLabel() {
        typePlaceNameLabel.textAlignment = .left
        typePlaceNameLabel.textColor = UIColor.white
        typePlaceNameLabel.translatesAutoresizingMaskIntoConstraints = false
        typePlaceNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        typePlaceNameLabel.topAnchor.constraint(equalTo: placeNameLabel.bottomAnchor, constant: 10).isActive = true
        typePlaceNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
    }
    
    func customizeEpisode() {
        episodes.textAlignment = .left
        episodes.textColor = UIColor.white
        episodes.translatesAutoresizingMaskIntoConstraints = false
        episodes.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12).isActive = true
        episodes.topAnchor.constraint(equalTo: typePlaceNameLabel.bottomAnchor, constant: 10).isActive = true
        episodes.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
    }
    
    func customizeEpisodeTextView() {
        episodesTextView.textAlignment = .left
        episodesTextView.textColor = UIColor.white
        episodesTextView.translatesAutoresizingMaskIntoConstraints = false
        episodesTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12).isActive = true
        episodesTextView.topAnchor.constraint(equalTo: episodes.bottomAnchor, constant: 10).isActive = true
        episodesTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        episodesTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).isActive = true
        
        episodesTextView.isEditable = false
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
