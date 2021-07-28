//
//  ViewController.swift
//  task3.ios.school
//
//  Created by XO on 12.07.2021.
//  Copyright © 2021 XO. All rights reserved.
//

import UIKit


class ViewController: UIViewController, Routerable {
    
    typealias Router = MainRouting
    var router: MainRouting?
    var apiManager: ApiManager?
    
    let tableView = UITableView.init(frame: .zero, style: .plain)
    var cellIdentifier = "Cell"
    var characters1 = [Character]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    var CustomChar = [customizedCharacterResult]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Список персонажей"
        
        getCharacters()
//        CustomChar = apiManager?.getCustomCharactersFromFirstPage(character: characters1) as! [customizedCharacterResult] 
        createTableView()
        getCharactersTwoToLastPage(number: 34)
    }
    
    func getCharacters() {
        apiManager?.getCharactersFromFirstPage { result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let characters):
                self.characters1.append(contentsOf: characters)
                self.characters1 = self.characters1.sorted { ($0.id < $1.id) }
                }
            }
        }
    
    func getCharactersTwoToLastPage(number: Int) {
        apiManager?.getCharactersTwoToLastPage(numberOfPages: number) { result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let characters):
                self.characters1.append(contentsOf: characters)
                self.characters1 = self.characters1.sorted { ($0.id < $1.id) }
            }
        }
    }
    
        func createTableView() {
        tableView.register(CharacterTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 80
        view.addSubview(self.tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor)])
    }


}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characters1.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CharacterTableViewCell
        let characterCell = characters1[indexPath.row]
        cell.addParams(Character: characterCell)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.allowsSelection = true
        tableView.deselectRow(at: indexPath, animated: true)
        
        router?.goToDetailModule(character: characters1[indexPath.row])
    }
}
