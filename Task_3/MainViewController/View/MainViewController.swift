//
//  MainViewController.swift
//  Task_3
//
//  Created by KirRealDev on 11.07.2021.
//

import UIKit

protocol MainViewControllerDelegate: AnyObject {
    func initCharacterCard(_ id: Int)
}

class MainViewController: UIViewController, MainViewModelDelegate {
    
    @IBOutlet private weak var mainTableView: UITableView!
    
    private let MainTableViewCellIdentifier = "characterCell"
    private let showDetailViewSegueIdentifier = "showDetailVC"
    
    private let heightForRow: CGFloat = 112.0
    
    private var dataArray = [Result]()
    
    weak var mainViewDelegate: MainViewControllerDelegate? = nil
    
    private let mainViewModel = MainViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "list of characters"
        mainViewModel.delegate = self
        configureTableView()
        mainViewModel.loadInformation()
//
        
//        let charactersDispatchGroup = DispatchGroup()
//        for i in 2...5 {
//            queueForLoadAdditionalPages.async(group: charactersDispatchGroup) {
//                self.loadCharacterInformation(urlString: "https://rickandmortyapi.com/api/character?page=" + String(i), characterId: i)
//                //print("DONE,", i)
//            }
//        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        let pageId: Int = 1
//        DispatchQueue.global(qos: .userInitiated).async {
//            self.loadCharacterInformation(urlString: "https://rickandmortyapi.com/api/character", characterId: pageId)
//        }
//
//        let charactersDispatchGroup = DispatchGroup()
//        for i in 2...5 {
//            queueForLoadAdditionalPages.async(group: charactersDispatchGroup) {
//                self.loadCharacterInformation(urlString: "https://rickandmortyapi.com/api/character?page=" + String(i), characterId: i)
//                //print("DONE,", i)
//            }
//        }
        
        
//        charactersDispatchGroup.notify(queue: DispatchQueue.main) {
//            for i in 2...5 {
//                print("DONE,", i)
//            }
//        }
        
//        defaultGlobal.async {
//            loadCharacterInformation(urlString: "https://rickandmortyapi.com/api/character?page=" + String(i))
//        }
    }
    

    
//    func loadCharacterInformation(urlString: String, characterId: Int) {
//        NetworkService.performGetRequest(url: urlString, pageId: characterId, onComplete: { [weak self] (data, id) in
//                self?.dictOfPages[id] = data.results
//                print("HELLO", id)
//                //print(self?.characterInfo!)
//
//
//                if (self?.currentPage == 1) {
//                    self?.characterInfo = self?.dictOfPages[self?.currentPage ?? 1]
//                    self?.mainTableView.reloadData()
//                    //self?.queueForLoadAdditionalPages.activate()
//                    self?.asyncDownloadCharactersInfo(count: 10, with: 3)
//                }
//
//                if (id == self?.currentPage) {
//                    self?.currentPage = (self?.currentPage ?? 0) + 1
//                    //self?.characterInfo?.append(contentsOf: (self?.dictOfPages[id]!)!)
//                    print("обновил с ID = ", id)
//                }
//                print(self?.currentPage)
//        }) { (error, id) in
//                NSLog(error.localizedDescription)
//                print("HELLO", id)
//           }
//    }
    
//    func loadCharacterAdditionalInformation(urlString: String, characterId: Int) {
//        NetworkService.performGetRequest(url: urlString, pageId: characterId, onComplete: { [weak self] (data, id) in
//                print("HELLO", id)
//                self?.dictOfPages[id] = data
//                self?.mainTableView.reloadData() }) { (error, id) in
//                NSLog(error.localizedDescription)
//                print("HELLO", id)
//           }
//    }
    func updateTableViewBy(item: [Result]) {
        self.dataArray = self.dataArray + item
        self.mainTableView.reloadData()
    }
    
    func updateDataBy(item: [Result]) {
        self.dataArray = self.dataArray + item
        self.mainTableView.reloadData()
    }
    
    private func configureTableView() {
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.register(UINib(nibName: String(describing: CharacterTableViewCell.self), bundle: nil), forCellReuseIdentifier: MainTableViewCellIdentifier)
    }
    
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightForRow
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = mainTableView.dequeueReusableCell(withIdentifier: MainTableViewCellIdentifier) as? CharacterTableViewCell else {
            return UITableViewCell()
        }
       
        if dataArray.count == 0 {
            return UITableViewCell()
        }
        
        cell.configure(dataArray[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        mainTableView.deselectRow(at: indexPath, animated: true)
        let detailViewController = storyboard?.instantiateViewController(identifier: "detailViewIdentifier") as! DetailViewController

        mainViewDelegate = detailViewController
        print("I'm create")
        mainViewDelegate?.initCharacterCard(dataArray[indexPath.row].id)
        navigationController?.pushViewController(detailViewController, animated: true)
    }

}

