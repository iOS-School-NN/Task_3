//
//  CharacterDetailVC.swift
//  Rick&MortyApp
//
//  Created by Alexander on 12.07.2021.
//

import UIKit

final class CharacterDetailVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        headerView.fill(character)
        locationView.fill(Location(name: "Citadel of Ricks", type: "Space station"))
        episodesView.fill([
            Episode(name: "The Ricklantis Mixup", code: "S03E07", date: "September 10, 2017"),
            Episode(name: "The Ricklantis Mixup", code: "S03E07", date: "September 10, 2017"),
            Episode(name: "The Ricklantis Mixup", code: "S03E07", date: "September 10, 2017"),
            Episode(name: "The Ricklantis Mixup", code: "S03E07", date: "September 10, 2017")
        ])
    }
    
    init(character: Character) {
        self.character = character
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let padding: CGFloat = 8
    private let character: Character
    private let headerView = CharacterHeaderView()
    private let locationView = CharacterLocationView()
    private let episodesView = CharacterEpisodesView()
    
    private func configure() {
        navigationItem.title = character.name
        view.backgroundColor = .white
        
        view.addSubview(headerView)
        view.addSubview(locationView)
        view.addSubview(episodesView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        locationView.translatesAutoresizingMaskIntoConstraints = false
        episodesView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
            headerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
            headerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: padding),
            
            locationView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: padding * 2),
            locationView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
            locationView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: padding),
            
            episodesView.topAnchor.constraint(equalTo: locationView.bottomAnchor, constant: padding * 2),
            episodesView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
            episodesView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: padding)
        ])
    }
}
