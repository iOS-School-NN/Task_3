//
//  MainViewController.swift
//  Task_3
//
//  Created by KirRealDev on 11.07.2021.
//

import UIKit

protocol MainViewControllerDelegate: AnyObject {
    func initCharacterCard(_ item: Result)
}

class MainViewController: UIViewController, MainViewModelDelegate {
    
    @IBOutlet private weak var mainTableView: UITableView!
    
    private let MainTableViewCellIdentifier = "characterCell"
    private let showDetailViewSegueIdentifier = "showDetailVC"
    
    private var dataArray = [Result]()
    
    weak var mainViewDelegate: MainViewControllerDelegate? = nil
    
    private let model = MainViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "list of characters"
        model.delegate = self
        configureTableView()
        model.loadStartInformation()
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
//        self.dataArrayForHorizontalCell = item[0]
//        self.dataArrayForTwoSquareItemCell = [CatModelElement]()
//        for iter in 1..<3 {
//            self.dataArrayForTwoSquareItemCell?.append(item[iter])
//        }
//        self.dataArrayForCollectionItemCell = [CatModelElement]()
//        for iter in 3..<6 {
//            self.dataArrayForCollectionItemCell?.append(item[iter])
//        }
        self.dataArray = item
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
    
    
//    private func createNewRow(forItemAtIndex index: Int) {
//        let indexPath = IndexPath(row: index, section: 0)
//
//        if self.mainTableView.indexPathsForVisibleRows?.contains(indexPath) ?? false {
//            self.mainTableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .fade)
//        }
//    }
    
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 112.0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = mainTableView.dequeueReusableCell(withIdentifier: MainTableViewCellIdentifier) as? CharacterTableViewCell else {
            return UITableViewCell()
        }
       
        if dataArray.count == 0 {
            return UITableViewCell()
        }
        
//        if indexPath.row == self.characterInfo?.count {
//              loadNextCell()
//              return cell
//        }
//        let lastRow = indexPath.row
//        if indexPath.row == item.count - 1 {
//            loadNextCell(indexPathRow: indexPath.row)
//            //return
//        }
        
        cell.configure(dataArray[indexPath.row])
        return cell
    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        mainTableView.deselectRow(at: indexPath, animated: true)
        //performSegue(withIdentifier: showDetailViewSegueIdentifier, sender: self)
        let detailViewController = storyboard?.instantiateViewController(identifier: "detailViewIdentifier") as! DetailViewController
//        guard let item = characterInfo?[indexPath.row] else {
//            return
//        }
        mainViewDelegate = detailViewController
        print("I'm create")
        mainViewDelegate?.initCharacterCard(dataArray[indexPath.row])
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
//    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
//        print("MMMMMMm")
//        guard let item = self.characterInfo else {
//            return
//        }
//
//        if indexPath.row == item.count - 1 {
//            loadNextCell(indexPathRow: indexPath.row)
//            //return
//        }
//        let lastRow = indexPath.row
//                if lastRow == item.count - 1 {
//                    print("FFFF")
//                }
//    }

}

