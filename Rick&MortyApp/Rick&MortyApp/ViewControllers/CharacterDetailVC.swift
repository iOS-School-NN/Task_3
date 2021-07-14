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
        self.networkService = networkService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let character: Character
    private let networkService: NetworkService
    
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
            headerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: padding),
            
            locationView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: padding * 2),
            locationView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
            locationView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: padding),
            
            episodesView.topAnchor.constraint(equalTo: locationView.bottomAnchor, constant: padding * 2),
            episodesView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
            episodesView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: padding)
        ])
    }
    
    private func fillHeaderView() {
        headerView.fill(character: character)
        
        networkService.downloadImage(url: character.imageUrl) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let imageData):
                DispatchQueue.main.async {
                    self.headerView.characterImage = UIImage(data: imageData)
                }
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
    
    private func fillLocationView() {
        networkService.getLocation(url: character.locationUrl) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let location):
                DispatchQueue.main.async {
                    self.locationView.fill(location)
                }
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
    
    private func fillEpisodesView() {
        networkService.getEpisodes(urls: character.episodesUrls) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let episodes):
                DispatchQueue.main.async {
                    self.episodesView.fill(episodes)
                }
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
}
