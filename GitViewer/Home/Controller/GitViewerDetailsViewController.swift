//
//  GitViewerDetailsViewController.swift
//  GitViewer
//
//  Created by Decagon on 10/11/2022.
//

import UIKit
import SafariServices
import APIModels
import Utility

class GitDetailViewController: UIViewController {
    lazy var detailsView = GitDetailView()
    var userDefault = UserDefaults.standard
    var userDetails: APIModels.Item?
    var following: Int?
    var followers: Int?
    var listOfLiked = [APIModels.Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        view.backgroundColor = .systemBackground
    }
    
    private func setupViews() {
        view.addSubview(detailsView)
        NSLayoutConstraint.activate([
            detailsView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            detailsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            detailsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            detailsView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        detailsView.editTapped = { [weak self] link in
            self?.openLink(link)
        }
        
        if let userDetails = userDetails{
            detailsView.configureFields(userDetails, following: following ?? 0, followers: followers ?? 0)
        }
        
        listOfLiked = userDefault.favourites ?? []
        
        detailsView.favouriteTapped = {[weak self] in
            self?.listOfLiked.append((self?.userDetails)!)
            let setArr = self?.listOfLiked.removingDuplicates()
            if setArr == self?.listOfLiked {
                if self?.listOfLiked.count == 0 {
                    self?.detailsView.favouriteSuccessLabel.text = "Uh oh! you don't have any favs"
                    self?.detailsView.favouriteSuccessLabel.isHidden = false
                }
                self?.userDefault.favourites = self?.listOfLiked
                self?.detailsView.favouriteSuccessLabel.isHidden = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self?.detailsView.favouriteSuccessLabel.isHidden = true
                   }
            }else{
                self?.listOfLiked.removeLast()
                self?.detailsView.favouriteSuccessLabel.text = "This has already been added to favourites"
                self?.detailsView.favouriteSuccessLabel.isHidden = false
                self?.detailsView.favouriteSuccessLabel.backgroundColor = .gray
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self?.detailsView.favouriteSuccessLabel.isHidden = true
                   }
            }
        }
    }
    
    func openLink(_ url: URL) {
        let safariVc = SFSafariViewController(url: url)
        self.navigationController?.present(safariVc, animated: true, completion: nil)
    }
}

