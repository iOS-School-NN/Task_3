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

    }

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

