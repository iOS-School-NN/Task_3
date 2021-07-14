//
//  CharacterTableViewCell.swift
//  RickAndMortyApp
//
//  Created by Grifus on 10.07.2021.
//

import UIKit

class CharacterTableViewCell: UITableViewCell {

    @IBOutlet weak var characterImage: UIImageView!
    
    @IBOutlet weak var characterName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        accessoryType = .disclosureIndicator
    }
    
    func setupName(data: Result) {
        characterName.text = data.name + " id: \(data.id)"
    }
    
    func setupImage(imageString: String) {
        let session = URLSession.shared
        let imageURL = URL(string: imageString)
        session.dataTask(with: imageURL!) { (data, response, error) in
            self.characterImage.image = UIImage(data: data!)
        }
    }
 
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
