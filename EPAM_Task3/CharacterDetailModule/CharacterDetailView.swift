import UIKit

protocol CharacterDetailViewProtocol: AnyObject {
    func setInformation(imageData: Data?, name: String, gender: String, status: String, species: String)
    func setLocation(name: String, type: String)
    func setEpisode(episode: String, name: String, airDate: String)
    func setImage(image: UIImage)
}

final class CharacterDetailView: UIViewController, CharacterDetailViewProtocol {
    var presenter: CharacterDetailPresenterProtocol!

    // Изображение персонажа
    private let characterImage: UIImageView = {
        let characterImage = UIImageView()
        characterImage.translatesAutoresizingMaskIntoConstraints = false
        characterImage.layer.cornerRadius = UIScreen.main.bounds.width * 0.06
        characterImage.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMaxYCorner]
        characterImage.clipsToBounds = true
        characterImage.backgroundColor = .orange
        return characterImage
    }()

    private func characterImageConstraints() {
        NSLayoutConstraint.activate([
            characterImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            characterImage.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 10),
            characterImage.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.45),
            characterImage.heightAnchor.constraint(equalTo: characterImage.widthAnchor)
        ])
    }

    // Основная информация о персонаже
    private let informationLabel: UILabel = {
        let informationLabel = UILabel()
        informationLabel.translatesAutoresizingMaskIntoConstraints = false
        informationLabel.numberOfLines = 0
        informationLabel.lineBreakMode = .byWordWrapping
        informationLabel.frame.size.width = UIScreen.main.bounds.width * 0.40
        informationLabel.sizeToFit()

        return informationLabel
    }()

    private func informationLabelConstraints() {
        NSLayoutConstraint.activate([
            informationLabel.centerYAnchor.constraint(equalTo: characterImage.centerYAnchor),
            informationLabel.leftAnchor.constraint(equalTo: characterImage.rightAnchor, constant: 10),
            informationLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.40),
            informationLabel.heightAnchor.constraint(equalTo: characterImage.widthAnchor)
        ])
    }

    // Заголовок "Локация"
    private let locationTitle: UILabel = {
        let locationTitle = UILabel()
        locationTitle.translatesAutoresizingMaskIntoConstraints = false
        locationTitle.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        locationTitle.text = "Location:"

        return locationTitle
    }()

    private func locationTitleConstraints() {
        NSLayoutConstraint.activate([
            locationTitle.topAnchor.constraint(equalTo: characterImage.bottomAnchor, constant: 10),
            locationTitle.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 10),
            locationTitle.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10)
        ])
    }

    // Информация о локации
    private let locationLabel: UILabel = {
        let locationLabel = UILabel()
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.numberOfLines = 0
        locationLabel.lineBreakMode = .byWordWrapping
        locationLabel.frame.size.width = UIScreen.main.bounds.width - 20
        locationLabel.sizeToFit()

        return locationLabel
    }()

    private func locationLabelConstraints() {
        NSLayoutConstraint.activate([
            locationLabel.topAnchor.constraint(equalTo: locationTitle.bottomAnchor, constant: 10),
            locationLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 10),
            locationLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),

        ])
    }

    // Заголовок "Эпизоды"
    private let episodesTitle: UILabel = {
        let episodesTitle = UILabel()
        episodesTitle.translatesAutoresizingMaskIntoConstraints = false
        episodesTitle.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        episodesTitle.text = "Episodes:"

        return episodesTitle
    }()

    private func episodesTitleConstraints() {
        NSLayoutConstraint.activate([
            episodesTitle.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 10),
            episodesTitle.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 10),
            episodesTitle.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),

        ])
    }

    // Информация об эпизодах
    private let episodesTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.isEditable = false
        textView.isSelectable = false
        return textView
    }()

    private func episodesTextViewConstraints() {
        NSLayoutConstraint.activate([
            episodesTextView.topAnchor.constraint(equalTo: episodesTitle.bottomAnchor, constant: 10),
            episodesTextView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 10),
            episodesTextView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            episodesTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10)
        ])
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.largeTitleDisplayMode = .always

        view.addSubview(characterImage)
        characterImageConstraints()

        view.addSubview(informationLabel)
        informationLabelConstraints()

        view.addSubview(locationTitle)
        locationTitleConstraints()

        view.addSubview(locationLabel)
        locationLabelConstraints()

        view.addSubview(episodesTitle)
        episodesTitleConstraints()

        view.addSubview(episodesTextView)
        episodesTextViewConstraints()
    }

    // Установка изображения персонажа (вызывается из презентера)
    func setImage(image: UIImage) {
        characterImage.image = image
    }

    // Установка информации о персонаже (вызывается из презентера)
    func setInformation(imageData: Data?, name: String, gender: String, status: String, species: String) {
        if let imageData = imageData {
            characterImage.image = UIImage(data: imageData)
        }

        navigationItem.title = name
        informationLabel.text = "Name: \(name)\nGender: \(gender)\nStatus: \(status)\nSpecies: \(species)"
    }

    // Установка информации о локации (вызывается из презентера)
    func setLocation(name: String, type: String) {
        locationLabel.text = "• \(name)\n• \(type)"
    }

    // Установка информации об одном из эпизодов (вызывается из презентера)
    func setEpisode(episode: String, name: String, airDate: String) {
        episodesTextView.text += "• \(episode)\\ \(name)\\ \(airDate)\n"
    }
}
