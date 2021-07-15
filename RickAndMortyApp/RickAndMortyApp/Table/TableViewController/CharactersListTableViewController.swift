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
                print("reload table")
                self.tableView.reloadData()
            }
        }
    }
    var characterImages = [Int: Data]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSourse.delegate = self
        //        downloadFirstPage()
        dataSourse.download()
        
        //        startGroup.notify(queue: DispatchQueue.global()) {
        //            self.downloadThreePages()
        //        }
    }
    
    // MARK: - Table view data source
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let characterDetail = self.storyboard?.instantiateViewController(withIdentifier: "Detail") as! DetailViewController
        characterDetail.title = charactersArr[0].results[indexPath.row].name
        characterDetail.id = charactersArr[0].results[indexPath.row].id
        navigationController?.pushViewController(characterDetail, animated: true)
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if charactersArr.count == 0 {return 0}
        return charactersArr[0].results.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CharacterCell", for: indexPath) as! CharacterTableViewCell
        
        if charactersArr.count == 0 { return cell }
        cell.setupName(data: charactersArr[0].results[indexPath.row])
        
        cell.characterImage.image = nil
        print("create cell \(indexPath.row)")
        
        dataSourse.downloadPhotos(photoIndex: indexPath, photoString: charactersArr[0].results[indexPath.row].image)
        //        let download = self.downloadPhotos(photoIndex: indexPath)
        cell.setupImage(imageData: self.characterImages[indexPath.row])
        //        if fetchImageList[indexPath.row] != nil {return cell} //с этим не разобрался
        //        fetchImageList[indexPath.row] = download
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if characterImages[indexPath.row] != nil { return }
        dataSourse.cancelDownloadPhoto(row: indexPath.row)
    }
}
// MARK: - Business logic

extension CharactersListTableViewController: CharacterCardBusinessModelDelegate {
    
    func recivePhoto(indexPath: IndexPath, photoData: Data) {
        characterImages[indexPath.row] = photoData
        DispatchQueue.main.async {
            guard let cell = self.tableView.cellForRow(at: indexPath) as? CharacterTableViewCell else { return }
            print("setup image")
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
        DispatchQueue.main.async {
            self.lock.lock()
            self.charactersArr[0].results.sort { (one, two) -> Bool in
                one.id < two.id
            }
            self.lock.unlock()
        }
    }
}
