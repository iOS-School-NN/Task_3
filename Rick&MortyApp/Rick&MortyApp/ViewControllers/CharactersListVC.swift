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
        fetchData()
    }
    
    private let networkService = NetworkService()
    private var data = [Character]()
    private var isPaginating = false
    private var nextPageUrl = "https://rickandmortyapi.com/api/character/"
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(CharacterCell.self, forCellReuseIdentifier: CharacterCell.cellId)
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    private let loaderView = LoaderView()
    
//    private lazy var loaderView: UIStackView = {
//        let stack = UIStackView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 200))
//        let spinner = UIActivityIndicatorView()
//        spinner.backgroundColor = .white
//        spinner.startAnimating()
//        stack.addArrangedSubview(spinner)
//        stack.translatesAutoresizingMaskIntoConstraints = false
//        return stack
//    }()
    
    private func configure() {
        navigationItem.title = "Characters list"
        
        view.addSubview(tableView)
        view.addSubview(loaderView)
        loaderView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            loaderView.topAnchor.constraint(equalTo: tableView.bottomAnchor),
            loaderView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loaderView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loaderView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func fetchData() {
        isPaginating = true
        loaderView.isShown = true
        
        networkService.getCharactersPage(url: nextPageUrl) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let characterPage):
                self.data.append(contentsOf: characterPage.1)
                self.nextPageUrl = characterPage.0.next ?? ""
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.isPaginating = false
                    self.loaderView.isShown = false
                }
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
}

extension CharactersListVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CharacterCell.cellId, for: indexPath)
        guard let characteCell = cell as? CharacterCell else { assertionFailure(); return cell }
        let character = data[indexPath.row]
        
        characteCell.fill(name: character.name)
        networkService.downloadImage(url: character.imageUrl) {
            switch $0 {
            case .success(let imageData):
                DispatchQueue.main.async {
                    characteCell.characterImage = UIImage(data: imageData)
                }
            case .failure(let error):
                print(String(describing: error))
            }
        }
        return characteCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CharacterCell.cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let characterDetailVC = CharacterDetailVC(character: data[indexPath.row], networkService: networkService)
        navigationController?.pushViewController(characterDetailVC, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        if offsetY > tableView.contentSize.height - scrollView.frame.size.height {
            if isPaginating { return }
            fetchData()
        }
    }
}
