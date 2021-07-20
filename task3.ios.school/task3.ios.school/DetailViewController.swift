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
    
    let nameLabel = UILabel()
    let genderLabel = UILabel()
    let statusLabel = UILabel()
    let kindLabel = UILabel()
    var imageView = UIImageView(frame: .zero)
    let place = UILabel()
    let placeNameLabel = UILabel()
    let typePlaceNameLabel = UILabel()
    let episodes = UILabel()
//    let
    
    var router: Router?
    var passedCharacter: Character?
    var passedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = passedCharacter?.name
        view.addSubview(imageView)
        view.addSubview(nameLabel)
        view.addSubview(genderLabel)
        view.addSubview(statusLabel)
        view.addSubview(kindLabel)
        view.addSubview(place)
        view.addSubview(placeNameLabel)
        view.addSubview(typePlaceNameLabel)
        view.addSubview(episodes)
        customizeDetailVC(character: passedCharacter!, image: passedImage!)
    
        

        
        // Do any additional setup after loading the view.
    }
    
    func customizeDetailVC(character: Character, image: UIImage) {
        fillAllfields(character: character)
        customizeImageView(image: image)
        customizeNameLabel()
        customizeGenderLabel()
        customizeStatusLabel()
        customizeKindLabel()
        customizePlace()
        customizePlaceNameLabel()
        
    }
    
    func fillAllfields(character: Character) {
        nameLabel.text = character.name
        genderLabel.text = character.gender
        statusLabel.text = character.status
        kindLabel.text = character.species
        place.text = "Location:"
        placeNameLabel.text = "•" + character.location.name
        typePlaceNameLabel.text = "•" + character.location.url
        episodes.text = "Episodes"
    }
    
    func customizeImageView (image: UIImage) {
        imageView.image = image
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
