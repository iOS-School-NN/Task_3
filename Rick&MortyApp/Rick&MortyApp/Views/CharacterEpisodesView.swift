//
//  CharacterEpisodesView.swift
//  Rick&MortyApp
//
//  Created by Alexander on 12.07.2021.
//

import UIKit

final class CharacterEpisodesView: UIView {
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fill(_ episodes: [Episode]) {
        episodes.forEach {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 20)
            label.numberOfLines = 0
            label.text = "- \($0.name) / \($0.code) / \($0.date)"
            stackView.addArrangedSubview(label)
        }
    }
    
    private let episodesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.text = "Episodes:"
        return label
    }()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 8
        return stack
    }()
    
    private func configure() {
        addSubview(episodesLabel)
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            episodesLabel.topAnchor.constraint(equalTo: topAnchor),
            episodesLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            episodesLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            stackView.topAnchor.constraint(equalTo: episodesLabel.bottomAnchor, constant: 8),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            stackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
