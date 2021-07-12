//
//  CharactersListVC.swift
//  Rick&MortyApp
//
//  Created by Alexander on 12.07.2021.
//

import UIKit

final class CharactersListVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private var data = Array(repeating: Character(name: "Rick Sanchez",
                                                  gender: "Male",
                                                  status: "Alive",
                                                  species: "Human",
                                                  imageUrl: "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
                                                  locationUrl: "",
                                                  episodesUrls: []),
                             count: 5)
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    private func configure() {
        view.backgroundColor = .systemTeal
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func configure(cell: UITableViewCell, by item: Character) {
        var content = cell.defaultContentConfiguration()
        content.text = item.name
        content.image = item.image
        content.imageProperties.reservedLayoutSize = CGSize(width: 20, height: 20)
        
        cell.contentConfiguration = content
        cell.separatorInset = .zero
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
    }
}

extension CharactersListVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        configure(cell: cell, by: data[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let characterDetailVC = CharacterDetailVC(character: data[indexPath.row])
        navigationController?.pushViewController(characterDetailVC, animated: true)
    }
}
