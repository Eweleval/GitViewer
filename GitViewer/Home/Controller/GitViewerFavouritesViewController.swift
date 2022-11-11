//
//  GitViewerFavouritesViewController.swift
//  GitViewer
//
//  Created by Decagon on 10/11/2022.
//

import UIKit
import APIModels
import Utility

class FavouritesViewController: UIViewController {
    let userDefault = UserDefaults.standard
    var favouriteList: [Item]?
    
    private lazy var favouriteTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(GitTableViewCell.self, forCellReuseIdentifier: GitTableViewCell.identifier)
        return tableView
    }()
    
    lazy var EmptyLabel: UILabel = {
        let viewTitle = UILabel()
        viewTitle.translatesAutoresizingMaskIntoConstraints = false
        viewTitle.textAlignment = .center
        viewTitle.text = "You do not have any favourite!!"
        viewTitle.isHidden = true
        viewTitle.font = UIFont.boldSystemFont(ofSize: viewTitle.font.pointSize)
        return viewTitle
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "myBackground")
        title = Controller.favTitle
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if favouriteList?.count == 0 || favouriteList == nil {
            EmptyLabel.isHidden = false
        }
    }
    
    func setupViews() {
        [favouriteTableView, EmptyLabel].forEach {view.addSubview($0)}
        favouriteTableView.delegate = self
        favouriteTableView.dataSource = self
        
        favouriteList = userDefault.favourites
        
        NSLayoutConstraint.activate([
            favouriteTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            favouriteTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            favouriteTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            favouriteTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            EmptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            EmptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

extension FavouritesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        favouriteList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: GitTableViewCell.identifier,
            for: indexPath) as?
                GitTableViewCell else { return UITableViewCell() }
        if let data = favouriteList?[indexPath.row]{
            cell.recieveData(data: data)
        }
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteButton = UIContextualAction(style: .destructive, title: "Delete") { ( _, _, completion) in
            self.userDefault.favourites?.remove(at: indexPath.row)
            self.favouriteList?.remove(at: indexPath.row)
            self.favouriteTableView.reloadData()
            if self.favouriteList?.count == 0 {
                self.EmptyLabel.isHidden = false
            }
            completion(true)
        }
        let buttonConfig = UISwipeActionsConfiguration(actions: [deleteButton])
        return buttonConfig
    }
}
