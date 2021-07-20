//
//  CharactersListTableViewController.swift
//  RickAndMortyApp
//
//  Created by Grifus on 10.07.2021.
//

import UIKit

class CharactersListTableViewController: UITableViewController {
    
    let dataSourse = CharacterCardBusinessModel()
    let lock = NSLock()
    
    var charactersArr = [Character]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    var characterImages = [Int: Data]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSourse.delegate = self
        dataSourse.download()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        lock.lock()
        let characterDetail = self.storyboard?.instantiateViewController(withIdentifier: "Detail") as! DetailViewController
        characterDetail.title = charactersArr[0].results[indexPath.row].name
        characterDetail.id = charactersArr[0].results[indexPath.row].id
        navigationController?.pushViewController(characterDetail, animated: true)
        lock.unlock()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if charactersArr.count == 0 {return 0}
        return charactersArr[0].results.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CharacterCell", for: indexPath) as! CharacterTableViewCell
        
        if charactersArr.count == 0 { return cell }
        lock.lock()
        cell.setupName(data: charactersArr[0].results[indexPath.row])
        
        cell.characterImage.image = nil
        
        dataSourse.downloadPhotos(photoIndex: indexPath, photoString: charactersArr[0].results[indexPath.row].image)
        cell.setupImage(imageData: self.characterImages[indexPath.row])
        lock.unlock()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if characterImages[indexPath.row] != nil { return }
        dataSourse.cancelDownloadPhoto(row: indexPath.row)
    }
}
// MARK: - Business logic

extension CharactersListTableViewController: CharacterCardBusinessModelDelegate {
    
    func receivePhoto(indexPath: IndexPath, photoData: Data) {
        characterImages[indexPath.row] = photoData
        DispatchQueue.main.async {
            guard let cell = self.tableView.cellForRow(at: indexPath) as? CharacterTableViewCell else { return }
            cell.setupImage(imageData: self.characterImages[indexPath.row]!)
        }
    }
    
    func createCharacterArray(characterArray: Character) {
        charactersArr.append(characterArray)
    }
    
    func updateCharacterArray(character: [Result]) {
        charactersArr[0].results.append(contentsOf: character)
    }
    
    func sortArray() {
        DispatchQueue.global().async {
            self.lock.lock()
            if self.charactersArr.isEmpty { return }
            self.charactersArr[0].results.sort { (one, two) -> Bool in
                one.id < two.id
            }
            self.lock.unlock()
        }
    }
}
