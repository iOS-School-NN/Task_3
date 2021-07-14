//
//  CharacterCell.swift
//  Rick&MortyApp
//
//  Created by Alexander on 14.07.2021.
//

import UIKit

final class CharacterCell: UITableViewCell {
    static let cellId = "CharacterCellId"
    static let cellHeight: CGFloat = 56
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var characterImage: UIImage? {
        didSet {
            characterImageView.image = characterImage
        }
    }
    
    func fill(name: String) {
        characterImageView.image = UIImage(systemName: "person")
        nameLabel.text = name
    }
    
    private let padding: CGFloat = 8
    
    private let characterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .systemGray
        imageView.layer.cornerRadius = 5
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    private func configure() {
        accessoryType = .disclosureIndicator
        selectionStyle = .none
        
        contentView.addSubview(characterImageView)
        contentView.addSubview(nameLabel)
        NSLayoutConstraint.activate([
            characterImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            characterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            characterImageView.heightAnchor.constraint(equalToConstant: 40),
            characterImageView.widthAnchor.constraint(equalToConstant: 40),
            
            nameLabel.centerYAnchor.constraint(equalTo: characterImageView.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: characterImageView.trailingAnchor, constant: padding),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding)
        ])
    }
}
