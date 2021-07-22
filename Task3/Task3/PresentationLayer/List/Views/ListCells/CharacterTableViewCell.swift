//
//  CharacterTableViewCell.swift
//  Task3
//
//  Created by Mary Matichina on 20.07.2021.
//

import UIKit

final class CharacterTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var photoView: UIImageView!
    
    // MARK: - Properties
    
    private var character: Character?
    
    // MARK: - Configure
    
    func configure(character: Character) {
        
        nameLabel.text = character.name
        photoView.set(imageURL: character.image)
    }
}
