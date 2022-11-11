//
//  GitViewerDetailView.swift
//  GitViewer
//
//  Created by Decagon on 10/11/2022.
//

import UIKit
import APIModels
import Utility

class GitDetailView: UIView {

    lazy var topView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()

    lazy var lineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.1550922005)
        return view
    }()

    lazy var viewTitleLabel: UILabel = {
        let viewTitle = UILabel()
        viewTitle.translatesAutoresizingMaskIntoConstraints = false
        viewTitle.textAlignment = .center
        viewTitle.text = "Profile"
        viewTitle.font = UIFont.boldSystemFont(ofSize: viewTitle.font.pointSize)
        return viewTitle
    }()

    lazy var profileImageView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.0327676786)
        return view
    }()

    lazy var profileImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 45
        image.backgroundColor = .red
        return image
    }()

    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.text = "Chinonye Ndubueze"
        label.font = UIFont(name: "Helvetica Neue", size: 14)
        return label
    }()

    lazy var linkProfileImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.heightAnchor.constraint(equalToConstant: 16).isActive = true
        image.widthAnchor.constraint(equalToConstant: 16).isActive = true
        image.clipsToBounds = true
        image.layer.cornerRadius = 8
        image.backgroundColor = .red
        return image
    }()

    lazy var LinkProfileLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = .link
        label.text = "Click here to see my github profile"
        label.font = UIFont(name: "Helvetica Neue", size: 14)
        label.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(repoURLTap))
        label.addGestureRecognizer(tap)
        return label
    }()

    lazy var LinkProfileStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 16
        stack.alignment = .fill
        stack.distribution = .fill
        [self.linkProfileImage, self.LinkProfileLabel].forEach { stack.addArrangedSubview($0) }
        return stack
    }()

    lazy var followingImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.heightAnchor.constraint(equalToConstant: 16).isActive = true
        image.widthAnchor.constraint(equalToConstant: 16).isActive = true
        image.image = UIImage(systemName: "person.2")
        image.tintColor = UIColor(named: Color.titleColor)
        return image
    }()

    lazy var followingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.text = "Notification"
        label.font = UIFont(name: "Helvetica Neue", size: 14)
        label.isUserInteractionEnabled = true
        return label
    }()

    lazy var followingStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 16
        stack.alignment = .fill
        stack.distribution = .fill
        [self.followingImage, self.followingLabel].forEach { stack.addArrangedSubview($0) }
        return stack
    }()

    lazy var followersImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.heightAnchor.constraint(equalToConstant: 16).isActive = true
        image.widthAnchor.constraint(equalToConstant: 16).isActive = true
        image.image = UIImage(systemName: "person.2")
        image.tintColor = UIColor(named: Color.titleColor)
        
        return image
    }()

    lazy var followersLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.text = "Change Password"
        label.font = UIFont(name: "Helvetica Neue", size: 14)
        label.isUserInteractionEnabled = true
        return label
    }()

    lazy var followersStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 16
        stack.alignment = .fill
        stack.distribution = .fill
        [self.followersImage, self.followersLabel].forEach { stack.addArrangedSubview($0) }
        return stack
    }()

    lazy var favouriteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Add To Favourite", for: .normal)
        button.tintColor = .white
        button.backgroundColor = .systemBlue
        button.addTarget(self, action: #selector(favouriteTap), for: .touchUpInside)
        return button
    }()
    
    lazy var favouriteSuccessLabel: UILabel = {
     let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Helvetica Neue", size: 16)
        label.textAlignment = .center
        label.text = "Fav added successfully"
        label.textColor = .white
        label.layer.cornerRadius = 15
        label.backgroundColor = .green
        label.layer.masksToBounds = true
        return label
    }()
    
    var favouriteTapped: (()-> Void)?
    var editTapped: ((URL)-> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        backgroundColor = .clear
        self.translatesAutoresizingMaskIntoConstraints = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var profileUrl: String?
    var starredUrl: String?

    func configureFields(_ data: Item, following: Int, followers: Int) {
        profileImage.downloadImage(from: data.avatarURL)
        nameLabel.text = data.login
        linkProfileImage.downloadImage(from: data.avatarURL)
        followersLabel.text = "\(followers) Followers"
        followingLabel.text = "\(following) Following"
        profileUrl = data.htmlURL
        starredUrl = data.starredURL
    }

    @objc func repoURLTap() {
        let url = URL(string: profileUrl ?? String())!
        editTapped?(url)
    }
    
    @objc func favouriteTap() {
        favouriteTapped?()
    }

    func setupSubviews() {
        [topView, lineView, profileImageView,
         LinkProfileStackView, followingStackView,
         followersStackView, favouriteButton, favouriteSuccessLabel].forEach { self.addSubview($0) }

        topView.addSubview(viewTitleLabel)
        [profileImage, nameLabel].forEach { profileImageView.addSubview($0) }
        favouriteSuccessLabel.isHidden = true

        NSLayoutConstraint.activate([
            topView.topAnchor.constraint(equalTo: self.topAnchor),
            topView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            topView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            topView.heightAnchor.constraint(equalToConstant: 48),

            viewTitleLabel.centerXAnchor.constraint(equalTo: topView.centerXAnchor),
            viewTitleLabel.bottomAnchor.constraint(equalTo: topView.bottomAnchor, constant: -8),

            lineView.topAnchor.constraint(equalTo: topView.bottomAnchor),
            lineView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            lineView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            lineView.heightAnchor.constraint(equalToConstant: 1),

            profileImageView.topAnchor.constraint(equalTo: lineView.bottomAnchor),
            profileImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            profileImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            profileImageView.heightAnchor.constraint(equalToConstant: 187),

            profileImage.centerXAnchor.constraint(equalTo: profileImageView.centerXAnchor),
            profileImage.topAnchor.constraint(equalTo: profileImageView.topAnchor, constant: 32),
            profileImage.heightAnchor.constraint(equalToConstant: 90),
            profileImage.widthAnchor.constraint(equalToConstant: 90),

            nameLabel.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 16),
            nameLabel.centerXAnchor.constraint(equalTo: profileImageView.centerXAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: -32),

            LinkProfileStackView.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 32),
            LinkProfileStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),

            followingStackView.topAnchor.constraint(equalTo: LinkProfileStackView.bottomAnchor, constant: 35),
            followingStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),

            followersStackView.topAnchor.constraint(equalTo: followingStackView.bottomAnchor, constant: 35),
            followersStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            
            favouriteButton.topAnchor.constraint(equalTo: followersStackView.bottomAnchor, constant: 80),
            favouriteButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            favouriteButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 40),
            favouriteButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -40),
            favouriteButton.heightAnchor.constraint(equalToConstant: 40),
            
            favouriteSuccessLabel.topAnchor.constraint(equalTo:favouriteButton.bottomAnchor, constant: 70),
            favouriteSuccessLabel.heightAnchor.constraint(equalToConstant: 30),
            favouriteSuccessLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 40),
            favouriteSuccessLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -40)
        ])
    }
}

