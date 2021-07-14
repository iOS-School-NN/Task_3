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
    let startGroup = DispatchGroup()
    
    var charactersArr = [Character]() {
        didSet {
            DispatchQueue.main.async {
//                self.lock.lock()
                self.charactersArr[0].results.sort { (one, two) -> Bool in
                one.id < two.id
            }
//                self.lock.unlock()
            }
        }
    }
    var characterImages = [Int: Data]()
    var dict = [Int: URLSessionDataTask]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        downloadFirstPage()
        
        startGroup.notify(queue: DispatchQueue.main) {
            self.downloadThreePages()
        }
    }
    
    // MARK: - Table view data source
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let characterDetail = self.storyboard?.instantiateViewController(withIdentifier: "Detail") as! DetailViewController
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
        
        cell.characterImage.image = nil
        
        if let image = characterImages[indexPath.row] {
            cell.characterImage.image = UIImage(data: image)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        print("will display cell \(indexPath.row)")
        
        let download = self.downloadPhotos(photoNumber: indexPath.row)
        download?.resume()
        dict[indexPath.row] = download
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
//        print("did end \(indexPath.row)")
    }
    
    
    
    // MARK: - Business logic
    
    func downloadFirstPage() {
        print("1")
        
        let url = URL(string: "https://rickandmortyapi.com/api/character/?page=1")
        
//        DispatchQueue.global().sync {
        startGroup.enter()
            self.session.dataTask(with: url!) { (data, response, error) in
                print("2")
                if let data = data {
                    let charList = try! self.decoder.decode(Character.self, from: data)
//                    self.lock.lock()
                    self.charactersArr.append(charList)
//                    self.lock.unlock()
                }
//                self.downloadThreePages()
                //self.downloadPhotos(startRow: 0, endRow: 19)
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                self.startGroup.leave()
            }.resume()
//        }
        print("3")
    }
    
    func downloadThreePages() {
        let concourentQueue = OperationQueue()
        concourentQueue.maxConcurrentOperationCount = 3
        
        for page in 2...34 {
            concourentQueue.addOperation {
                
                let url = URL(string: "https://rickandmortyapi.com/api/character/?page=\(page)")
                
                print("add operation \(page)")
                
//                sleep(2)
//                print("sleep")
                self.session.dataTask(with: url!) { (data, response, error) in
                    if let data = data {
                        
                        print("execution \(page)")
                        let charList = try! self.decoder.decode(Character.self, from: data)
                        
                        self.charactersArr[0].results.append(contentsOf: charList.results)
                       
                    }
                    
                    DispatchQueue.main.async {
//                        self.lock.lock()
//                        self.charactersArr[0].results.sort { (one, two) -> Bool in
//                            one.id < two.id
//                        }
//                        self.lock.unlock()
                        self.tableView.reloadData()
                    }
                }.resume()
            }
        }
    }
    
    func downloadPhotos(photoNumber: Int) -> URLSessionDataTask? {
        if self.characterImages[photoNumber] != nil { return nil }
        //        print("4")
        //        DispatchQueue.global().async {
        
        let downloading = self.session.dataTask(with: URL(string: self.charactersArr[0].results[photoNumber].image)!) { (data, response, error) in
//            sleep(2) // for testing cancel task
            print("5")
            print("downloaded photo \(photoNumber)")
            if let data = data {
                
                self.characterImages[photoNumber] = data
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        return downloading
        //        }
    }
    //                sleep(2)
    
}
