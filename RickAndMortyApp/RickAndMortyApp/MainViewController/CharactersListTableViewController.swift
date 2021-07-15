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
    let downloadImageGroup = DispatchGroup()
    
    var charactersArr = [Character]() {
        didSet {
//            DispatchQueue.main.async {
//                self.lock.lock()
//                self.charactersArr[0].results.sort { (one, two) -> Bool in
//                    one.id < two.id
//                }
//                print("sort")
//                self.lock.unlock()
//            }
//            startGroup.notify(queue: DispatchQueue.main) {
            DispatchQueue.main.async {
                print("reload table")
                self.tableView.reloadData()
            }
        }
    }
    var characterImages = [Int: Data]()
    var dict = [Int: URLSessionDataTask]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        downloadFirstPage()
        
        startGroup.notify(queue: DispatchQueue.global()) {
            print("start notify")
//            sleep(5)
            print("contine notify")
            self.downloadThreePages()
        }
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
        
        let download = self.downloadPhotos(photoIndex: indexPath)
        cell.setupImage(imageData: self.characterImages[indexPath.row])
        if dict[indexPath.row] != nil {return cell}
        dict[indexPath.row] = download
        //                if let image = characterImages[indexPath.row] {
        //                    cell.characterImage.image = UIImage(data: image)
        //                }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //        print("will display cell \(indexPath.row)")
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if dict[indexPath.row] != nil {
            dict[indexPath.row]?.cancel()
            if characterImages[indexPath.row] != nil { return }
            dict[indexPath.row] = nil
        }
        //        print("did end \(indexPath.row)")
    }
    
    // MARK: - Business logic
    
    func downloadFirstPage() {
        print("1")
        
        let url = URL(string: "https://rickandmortyapi.com/api/character/?page=1")
        
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
            
//            DispatchQueue.main.async {
//                print("reload after first page")
//                self.tableView.reloadData()
//            }
            self.startGroup.leave()
        }.resume()
        //        }
        print("3")
    }
    
    func downloadThreePages() {
        let concourentQueue = OperationQueue()
        concourentQueue.maxConcurrentOperationCount = 3
        
        for page in 2...charactersArr[0].info.pages {
            concourentQueue.addOperation {
                
                let url = URL(string: "https://rickandmortyapi.com/api/character/?page=\(page)")
                
                print("add operation \(page)")
                
//                sleep(5)
                //                print("sleep")
                self.session.dataTask(with: url!) { (data, response, error) in
                    if let data = data {
                        
                        print("execution \(page)")
                        let charList = try! self.decoder.decode(Character.self, from: data)
                        
                        self.charactersArr[0].results.append(contentsOf: charList.results)
                        
                    }
                    
                    DispatchQueue.main.async {
                        self.lock.lock()
                        self.charactersArr[0].results.sort { (one, two) -> Bool in
                            one.id < two.id
                        }
                        self.lock.unlock()
                        //                        print("reload table")
                        //                        self.tableView.reloadData()
                    }
                }.resume()
            }
        }
    }
    
    func downloadPhotos(photoIndex: IndexPath) -> URLSessionDataTask? {
        if dict[photoIndex.row] != nil { return nil}
        //        downloadImageGroup.enter()
        let downloading = self.session.dataTask(with: URL(string: self.charactersArr[0].results[photoIndex.row].image)!) { (data, response, error) in
            //            sleep(1) // for testing cancel task
            print("downloaded photo \(photoIndex)")
            if let data = data {
                
                self.characterImages[photoIndex.row] = data
                //                self.downloadImageGroup.leave()
                
                print("data \(self.characterImages[photoIndex.row])")
                DispatchQueue.main.async {
//                self.tableView.reloadData()
//                    //                print("reloading \(photoIndex)")
                    guard let cell = self.tableView.cellForRow(at: photoIndex) as? CharacterTableViewCell else { return }
                    //
                    cell.setupImage(imageData: self.characterImages[photoIndex.row]!)
//                    self.tableView.reloadRows(at: [photoIndex], with: .automatic)
                }
                
            }
        }
        downloading.resume()
        return downloading
    }
    
}
