//
//  DetailViewController.swift
//  Task3
//
//  Created by Mary Matichina on 11.07.2021.
//

import UIKit

final class DetailViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Properties
    
    private var viewModel = DetailViewModel()
    var character: Character?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureLoader()
        configureObserver()
        if let id = character?.id {
            viewModel.fetchData(id: id)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavBar()
    }
    
    // MARK: - Configure
    
    private func configureTableView() {
        tableView.separatorColor = .clear
    }
    
    private func configureNavBar() {
        title = character?.name ?? ""
    }
    
    private func configureLoader() {
        activityIndicator.isHidden = true
        activityIndicator.layer.cornerRadius = 10.0
        activityIndicator.layer.masksToBounds = true
    }
    
    private func showLoader() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    private func hideLoader() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    // MARK: - Observer
    
    private func configureObserver() {
        showLoader()
        viewModel.updateHandler = { [weak self] () in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.hideLoader()
            }
        }
    }
}

// MARK: - Extensions

extension DetailViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return viewModel.character != nil ? 1 : 0
        case 1:
            return viewModel.location != nil ? 2 : 0
        case 2:
            return viewModel.episodes.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = CharacterCardTableViewCell.createForTableView(tableView) as! CharacterCardTableViewCell
            if let character = viewModel.character {
                cell.configure(character: character)
            }
            return cell
        case 1:
            let location = viewModel.location
            let text = indexPath.row == 0 ? (location?.name ?? "") : (location?.type ?? "")
            return createTableViewCell(title: text)
        case 2:
            return createTableViewCell(title: viewModel.episodes[indexPath.row].episodeString)
        default:
            return UITableViewCell()
        }
    }
}

// MARK: Cell builder

extension DetailViewController {
    func createTableViewCell(title: String) -> UITableViewCell {
        let cell = TitleTableViewCell.createForTableView(tableView) as! TitleTableViewCell
        cell.configure(title: title)
        return cell
    }
}

extension DetailViewController: UITabBarDelegate {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch section {
        case 1:
            return viewModel.location != nil ? "Location" : nil
        case 2:
            return !viewModel.episodes.isEmpty ? "Episode" : nil
        default:
            return nil
        }
    }
}
