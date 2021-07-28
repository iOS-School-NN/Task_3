//
//  CharacterTableViewCell.swift
//  task3.ios.school
//
//  Created by XO on 19.07.2021.
//  Copyright © 2021 XO. All rights reserved.
//

import UIKit

class CharacterTableViewCell: UITableViewCell {
    let apiManager = ApiManager()
    
    var characterImageView = UIImageView()
    var characterTitleLabel = UILabel()
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(characterImageView)
        addSubview(characterTitleLabel)
        self.accessoryType = .disclosureIndicator
        configureTitleLabel()
        configureImageView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func set(character: Character) {
        let imageSource = character.image
        if let url = URL(string: imageSource) {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print(error)
                } else {
                    if let data = data, let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self.characterImageView.image = image
                        }
                    }
                }
                
            }
            task.resume()
        }
    }
    
    func addParams(Character: Character) -> Void {
        characterImageView.loadImageWithCache(from: Character.image) { (data, url) in
            if (Character.image == url) {
                DispatchQueue.main.async {
                    self.characterImageView.image = UIImage(data: data)
                }
            }
        }
        characterTitleLabel.text = Character.name
    }
    
    func configureImageView() {
        characterImageView.contentMode = .scaleToFill
        characterImageView.layer.cornerRadius = 10
        characterImageView.clipsToBounds = true
    }

    func configureTitleLabel() {
        characterTitleLabel.textColor = UIColor.white
        characterTitleLabel.numberOfLines = 0
        characterTitleLabel.adjustsFontSizeToFitWidth = true
    }
    
    func setConstraints() {
        characterImageView.translatesAutoresizingMaskIntoConstraints = false
        characterImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        characterImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        characterImageView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        characterImageView.widthAnchor.constraint(equalTo: characterImageView.heightAnchor).isActive = true
        
        characterTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        characterTitleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        characterTitleLabel.leadingAnchor.constraint(equalTo: characterImageView.trailingAnchor, constant: 20).isActive = true
        characterTitleLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        characterTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
    }
}
