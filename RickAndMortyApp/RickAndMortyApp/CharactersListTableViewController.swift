//
//  CharactersListTableViewController.swift
//  RickAndMortyApp
//
//  Created by Grifus on 10.07.2021.
//

import UIKit

class CharactersListTableViewController: UITableViewController {
    let lock = NSLock()
    let session = URLSession.shared
    let decoder = JSONDecoder()
    
    var charactersArr = [Character]()
    var characterImages = [Int: Data]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        downloadFirstPage()
        DispatchQueue.global().async {
//            self.downloadThreePages()
        }
    }
    
    // MARK: - Table view data source
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

//        navigationController?.performSegue(withIdentifier: "showDetailVC", sender: self)
        var characterDetail = self.storyboard?.instantiateViewController(withIdentifier: "Detail") as! DetailViewController
        characterDetail.title = charactersArr[0].results[indexPath.row].name
        characterDetail.id = indexPath.row + 1
        navigationController?.pushViewController(characterDetail, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if charactersArr.count == 0 {return 0}
        //print(charactersArr[0].results.count)
        return charactersArr[0].results.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CharacterCell", for: indexPath) as! CharacterTableViewCell
        
        if charactersArr.count == 0 { return cell }
        
        cell.setupName(data: charactersArr[0].results[indexPath.row])
        //                        cell.setupImage(imageString: charactersArr[0].results[indexPath.row].image)
        
        //        DispatchQueue.main.async {
        //            self.downloadPhotos(startRow: 0, endRow: 19)
        //        }
        cell.characterImage.image = nil
        if let image = characterImages[indexPath.row] {
            cell.characterImage.image = UIImage(data: image)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print("will display cell \(indexPath.row)")
        
        self.downloadPhotos(photoNumber: indexPath.row)
    }
    
    func downloadThreePages() {
        let concourentQueue = OperationQueue()
        concourentQueue.maxConcurrentOperationCount = 1
        
        for page in 2...34 {
            
            concourentQueue.addOperation {
                let url = URL(string: "https://rickandmortyapi.com/api/character/?page=\(page)")
                print("add operation \(page)")
                //        DispatchQueue.main.async {
                self.session.dataTask(with: url!) { (data, response, error) in
                    if let data = data {
                        //                    if page % 5 == 0 {sleep(3)
                        //                        print("sleep")
                        //                    }
                        print("execution \(page)")
                        
                        let charList = try! self.decoder.decode(Character.self, from: data)
                        self.charactersArr[0].results.append(contentsOf: charList.results)
                        //print(charList)
                    }
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    
                }.resume()
                //        }
            }
            
        }
    }
    
    func downloadFirstPage() {
        print("1")
        
        let url = URL(string: "https://rickandmortyapi.com/api/character/?page=1")
        
        DispatchQueue.global().sync {
            self.session.dataTask(with: url!) { (data, response, error) in
                
                print("2")
                if let data = data {
                    let charList = try! self.decoder.decode(Character.self, from: data)
                    self.charactersArr.append(charList)
                }
                self.downloadThreePages()
                //self.downloadPhotos(startRow: 0, endRow: 19)
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }.resume()
        }
        print("3")
    }
    
    func downloadPhotos(photoNumber: Int) {
        if self.characterImages[photoNumber] != nil { return }
        print("4")
        
        self.session.dataTask(with: URL(string: self.charactersArr[0].results[photoNumber].image)!) { (data, response, error) in
            print("5")
            print("downloaded photo \(photoNumber)")
            if let data = data {
                
                self.characterImages[photoNumber] = data
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }.resume()
        
    }
    //                sleep(2)
    
}
