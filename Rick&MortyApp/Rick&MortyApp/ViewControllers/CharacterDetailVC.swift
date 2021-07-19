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
        configureNavigationBar()
        configure()
        
        fillHeaderView()
        fillLocationView()
        fillEpisodesView()
    }
    
    init(character: Character, networkService: NetworkService) {
        self.character = character
        self.networkHandler = NetworkHandler(service: networkService)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let character: Character
    private let networkHandler: NetworkHandler
    
    private let padding: CGFloat = 8
    private let headerView = CharacterHeaderView()
    private let locationView = CharacterLocationView()
    private let episodesView = CharacterEpisodesView()
    
    private func configureNavigationBar() {
        navigationItem.title = character.name
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func configure() {
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
            headerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            
            locationView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: padding * 2),
            locationView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
            locationView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            
            episodesView.topAnchor.constraint(equalTo: locationView.bottomAnchor, constant: padding * 2),
            episodesView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
            episodesView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            episodesView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func fillHeaderView() {
        headerView.fill(character: character)
    }
    
    private func fillLocationView() {
        networkHandler.getLocation(url: character.locationUrl) { [weak self] location in
            guard let location = location else { return }
            DispatchQueue.main.async {
                self?.locationView.fill(location)
            }
        }
    }
    
    private func fillEpisodesView() {
        networkHandler.getEpisodes(urls: character.episodesUrls, completion: { [weak self] episodes in
            guard let episodes = episodes else { return }
            DispatchQueue.main.async {
                self?.episodesView.fill(episodes)
            }
        })
    }
}
