//
//  GitViewerTableViewCell.swift
//  GitViewer
//
//  Created by Decagon on 10/11/2022.
//

import UIKit
import APIModels

class GitTableViewCell: UITableViewCell {
    static let identifier = "GitCell"

    lazy var profileImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .center
        image.clipsToBounds = true
        image.layer.cornerRadius = 24
        image.backgroundColor = .tertiarySystemGroupedBackground
        image.image = UIImage(systemName: "person")
        image.tintColor = .black
        return image
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Ugochukwu Val"
        return label
    }()

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        [profileImage, nameLabel].forEach { contentView.addSubview($0) }
        NSLayoutConstraint.activate([
            profileImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            profileImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            profileImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            profileImage.heightAnchor.constraint(equalToConstant: 48),
            profileImage.widthAnchor.constraint(equalToConstant: 48),
            
            nameLabel.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 16),
            nameLabel.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor)
        ])
    }
    
    func recieveData(data: APIModels.Item) {
        nameLabel.text = data.login.capitalized
        profileImage.downloadImage(from: data.avatarURL)
        profileImage.contentMode = .scaleAspectFill
    }
}

