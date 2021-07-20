//
//  CharacterCardBusinessModel.swift
//  RickAndMortyApp
//
//  Created by Grifus on 15.07.2021.
//

import Foundation

protocol CharacterCardBusinessModelDelegate: AnyObject {
    func createCharacterArray(characterArray: Character)
    func updateCharacterArray(character: [Result])
    func receivePhoto(indexPath: IndexPath, photoData: Data)
    func sortArray()
}

class CharacterCardBusinessModel {
    
    weak var delegate: CharacterCardBusinessModelDelegate?
    let startGroup = DispatchGroup()
    let session = URLSession.shared
    let decoder = JSONDecoder()
    var pagesCount = 2
    var fetchImageList = [Int: URLSessionDataTask]()
    
    func download() {
        downloadFirstPage()
        
        startGroup.notify(queue: DispatchQueue.global()) {
            self.downloadThreePages(pagesCount: self.pagesCount)
        }
    }
    
    func downloadFirstPage() {
        let url = URL(string: "https://rickandmortyapi.com/api/character/?page=1")
        
        startGroup.enter()
        self.session.dataTask(with: url!) { (data, response, error) in
            if let data = data {
                let charList = try! self.decoder.decode(Character.self, from: data)
                self.delegate?.createCharacterArray(characterArray: charList)
                self.pagesCount = charList.info.pages
            }
            self.startGroup.leave()
        }.resume()
    }
    
    func downloadThreePages(pagesCount: Int) {
        let concourentQueue = OperationQueue()
        concourentQueue.maxConcurrentOperationCount = 3
        
        for page in 2...pagesCount {
            concourentQueue.addOperation {
                
                let url = URL(string: "https://rickandmortyapi.com/api/character/?page=\(page)")
                self.session.dataTask(with: url!) { (data, response, error) in
                    if let data = data {
                        let charList = try! self.decoder.decode(Character.self, from: data)
                        self.delegate?.updateCharacterArray(character: charList.results)
                    }
                    self.delegate?.sortArray()
                }.resume()
            }
        }
    }
    
    func downloadPhotos(photoIndex: IndexPath, photoString: String) {
        if fetchImageList[photoIndex.row] != nil { return }
        
        let downloading = session.dataTask(with: URL(string: photoString)!) { (data, response, error) in
            if let data = data {
                self.delegate?.receivePhoto(indexPath: photoIndex, photoData: data)
            }
        }
        downloading.resume()
        
        fetchImageList[photoIndex.row] = downloading
    }
    
    func cancelDownloadPhoto(row: Int) {
        if fetchImageList[row] != nil {
            fetchImageList[row]?.cancel()
            fetchImageList[row] = nil
        }
    }
}
