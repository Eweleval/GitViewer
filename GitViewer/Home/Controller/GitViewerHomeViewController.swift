//
//  GitViewerHomeViewController.swift
//  GitViewer
//
//  Created by Decagon on 10/11/2022.
//

import UIKit
import GitViewerNetwork
import APIModels
import Utility

class HomeViewController: UIViewController {

    var viewModel: GitDataViewModel?
    var gitUsers: [APIModels.Item]?
    var users = [APIModels.Item]()
    var sortedUsers: [String]?
    var sections: [[APIModels.Item]]?
    let queue = DispatchQueue(label: Controller.monitor)
    var pageNumber = 1
    var totalCount = 0
    var details: APIModels.Item?
    var following: Int?
    var followers: Int?
    
    private var newTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(GitTableViewCell.self, forCellReuseIdentifier: GitTableViewCell.identifier)
        return tableView
    }()
    
    lazy var favouriteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(Controller.favTitle, for: .normal)
        button.tintColor = .white
        button.backgroundColor = .systemBlue
        button.addTarget(self, action: #selector(viewFavourite), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: Color.backgroundColor)
        setupViews()
        setup()
    }
    
    private func setupViews() {
        [newTableView, favouriteButton].forEach { view.addSubview($0) }
        newTableView.dataSource = self
        newTableView.delegate = self
        NSLayoutConstraint.activate([
            newTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            newTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            newTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            newTableView.bottomAnchor.constraint(equalTo: favouriteButton.topAnchor),
            
            favouriteButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            favouriteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            favouriteButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            favouriteButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    fileprivate func setup() {
        navigationController?.navigationBar.prefersLargeTitles = true
        title = Controller.title
        
        viewModel?.getPageNumber(pageNumber: pageNumber)
//        viewModel?.receiveData()
        viewModel?.delegate = self
        viewModel?.monitorNetwork()
        viewModel?.monitor.start(queue: queue)
    }
    
    @objc func viewFavourite() {
        let favouriteVc = FavouritesViewController()
        navigationController?.pushViewController(favouriteVc, animated: true)
    }
}

extension HomeViewController: GitDataDelegate{
    func receiveData(_ data: APIModels.GitDataModel?) {
        if let data = data {
            totalCount = data.totalCount
            for user in data.items {
                users.append(user)
            }
        }
        gitUsers = users
        if let gitUser = gitUsers {
            let orderNames = gitUser.map { $0.headerOrder }
            let sectionHeader = Array(Set(orderNames))
            sortedUsers = sectionHeader.sorted()
            
            if let sortedLetters = sortedUsers {
                sections = sortedLetters.map { firstLetter in
                    return gitUser
                        .filter { $0.headerOrder == firstLetter}.sorted {$0.login < $1.login}
                }
            }
        }
        DispatchQueue.main.async {
            self.newTableView.reloadData()
        }
    }
    
    func receiveFollowersData(_ data: [APIModels.FollowDataModel]) {
        followers = data.count
        configureDetailsVC()
    }
    
    func receiveFollowingData(_ data: [APIModels.FollowDataModel]) {
        following = data.count
    }
    
    
}
extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        sections?.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections?[section].count ?? 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 60))
        header.backgroundColor = .tertiarySystemGroupedBackground
        let headerLabel = UILabel(frame: CGRect(x: 10, y: 5, width: header.frame.size.width, height: header.frame.size.height - 10))
        headerLabel.text = "\(sortedUsers?[section] ?? "")"
        headerLabel.font = .systemFont(ofSize: 30, weight: .heavy)
        header.addSubview(headerLabel)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: GitTableViewCell.identifier,
            for: indexPath) as?
                GitTableViewCell else { return UITableViewCell() }
        if let data = sections?[indexPath.section][indexPath.row] {
            cell.recieveData(data: data)
            cell.selectionStyle = .none
        }
        return cell
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard sections?.count ?? 0 > 0, indexPath.section == (sections?.count ?? 0) - 1 else { return }
        
        if let gitUsers = gitUsers {
            if indexPath.section == (sections?.count ?? 0) - 1 {
                if gitUsers.count < totalCount {
                    self.pageNumber += 1
                    self.self.viewModel?.getPageNumber(pageNumber: self.pageNumber)
                    self.viewModel?.receiveData()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        details = sections?[indexPath.section][indexPath.row]
        guard let following = details?.followingURL.dropLast(13) else { return }
        viewModel?.receiveFollowersData(details?.followersURL ?? "")
        viewModel?.receiveFollowingData("\(following)")
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func configureDetailsVC() {
        let detailVc = GitDetailViewController()
        detailVc.userDetails = details
        detailVc.following = following
        detailVc.followers = followers
        navigationController?.pushViewController(detailVc, animated: true)
    }
}

