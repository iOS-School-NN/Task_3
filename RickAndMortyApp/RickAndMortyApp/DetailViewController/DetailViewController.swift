//
//  DetailViewController.swift
//  RickAndMortyApp
//
//  Created by Grifus on 13.07.2021.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    @IBOutlet weak var characterImage: UIImageView!
    
    @IBOutlet weak var characterName: UILabel!
    
    @IBOutlet weak var characterGender: UILabel!
    
    @IBOutlet weak var characterStatus: UILabel!
    
    @IBOutlet weak var characterSpecies: UILabel!
    
    ///Location
    
    @IBOutlet weak var locationName: UILabel!
    
    @IBOutlet weak var locationType: UILabel!
    
    ///Episodes
    
    @IBOutlet weak var episodes: UITextView!
    
    let session = URLSession.shared
    let decoder = JSONDecoder()
    var detailData: CharacterDetailModel? {
        didSet {
            downloadByGroups()
        }
    }
    var id = 1
    var imageData: Data?
    var locationData: LocationStruct?
    var episodesFromNetwork = [Episode]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        indicator.startAnimating()
        
        downloadCharacretDetail(characterIndex: self.id)
        
        //downloadByGroups()
    }
    
    let group = DispatchGroup()
    let queue = DispatchQueue.global(qos: .userInteractive)
    
    func downloadByGroups() {
        
        print("start group")
        self.downloadPhoto()
        self.downloadLocation()
        self.downloadEpisodes()
        
        group.notify(queue: DispatchQueue.main) {
            self.setupUI()
            print("updated")
        }
    }
    
    func downloadCharacretDetail(characterIndex: Int) {
        let url = URL(string: "https://rickandmortyapi.com/api/character/\(characterIndex)")
        
        self.session.dataTask(with: url!) { (data, response, error) in
            print("start download card")
            if let data = data {
                print("downloading card")
                let characterData = try! self.decoder.decode(CharacterDetailModel.self, from: data)
                self.detailData = characterData
            }
            //self.downloadPhoto()
            //            sleep(2) //for testing
        }.resume()
    }
    
    func downloadPhoto() {
        print("downloading photo in")
        guard let data = detailData else { return }
        group.enter()
        self.session.dataTask(with: URL(string: data.image)!) { (data, response, error) in
            print("start download photo")
            if let data = data {
                self.imageData = data
            }
            //            self.downloadLocation()
            self.group.leave()
        }.resume()
    }
    
    func downloadLocation() {
        guard let data = detailData else { return }
        
        let url = URL(string: data.location.url)
        group.enter()
        self.session.dataTask(with: url!) { (data, response, error) in
            if let data = data {
                let locationData = try! self.decoder.decode(LocationStruct.self, from: data)
                self.locationData = locationData
            }
            self.group.leave()
            //            self.downloadEpisodes()
        }.resume()
    }
    
    func downloadEpisodes() {
        guard let data = detailData else { return }

        for episode in data.episode {
            let url = URL(string: episode)
            group.enter()
            self.session.dataTask(with: url!) { (data, response, error) in
                if let data = data {
                    let episodeData = try! self.decoder.decode(Episode.self, from: data)
                    self.episodesFromNetwork.append(episodeData)
                }
                print("finish downloadind episode")
                self.group.leave()
            }.resume()
        }
    }
    
    func setupUI() {
        guard let data = detailData else { return }
        guard let location = locationData else { return }
        characterName.text = data.name
        characterGender.text = data.gender
        characterStatus.text = data.status
        characterSpecies.text = data.species
        characterImage.image = UIImage(data: imageData!)
        locationName.text = location.name
        locationType.text = location.type
        for episode in episodesFromNetwork {
            episodes.text += "Name: \(episode.name), date: \(episode.air_date), episode: \(episode.episode) \n"
        }
        indicator.stopAnimating()
    }
    
    func updateUI() {
        print("start update")
        DispatchQueue.main.async {
            print("start setup")
            self.setupUI()
        }
    }
}

