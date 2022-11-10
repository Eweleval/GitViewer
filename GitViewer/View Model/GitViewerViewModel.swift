//
//  GitViewerViewModel.swift
//  GitViewer
//
//  Created by Decagon on 10/11/2022.
//

import Foundation
import Network
import Utility
import APIModels

protocol GitDataDelegate: AnyObject {
    func receiveData(_ data: APIModels.GitDataModel?)
    func receiveFollowersData(_ data: [APIModels.FollowDataModel])
    func receiveFollowingData(_ data: [APIModels.FollowDataModel])
}

class GitDataViewModel {
    
    
    weak var delegate: GitDataDelegate?
    var userDefaults = UserDefaults.standard
    let monitor = NWPathMonitor()
    var noNetwork = false
    var gitDataResource: GitDataResourceProtocol?
    var following: Int?
    var followers: Int?
    
    func getPageNumber(pageNumber: Int) {
        let urlString = "\(API.baseUrl)\(API.path)\(API.param)\(pageNumber)"
        gitDataResource = GitDataResource(urlString: urlString)
    }
    
    func monitorNetwork() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            if path.status == .satisfied {
                self.receiveData()
                self.noNetwork = true
            } else {
                self.delegate?.receiveData(self.userDefaults.offlineUsers)
            }
        }
    }
    
    func receiveData() {
        gitDataResource?.getGitData { [weak self] result in
            switch result {
            case .success(let listOf):
                self?.delegate?.receiveData(listOf)
                print(listOf, "Happy")
                self?.userDefaults.offlineUsers = listOf
            case .failure(let error):
                self?.delegate?.receiveData(self?.userDefaults.offlineUsers)
                print("Error processing json data: \(error.localizedDescription)")
            }
        }
    }
    
    func receiveFollowersData(_ url: String) {
        gitDataResource?.getFollowersData(url: url) { [weak self] result in
            switch result {
            case .success(let listOf):
                self?.delegate?.receiveFollowersData(listOf)
            case .failure(let error):
                print("Error processing json data: \(error.localizedDescription)")
            }
        }
    }
    
    func receiveFollowingData(_ url: String) {
        gitDataResource?.getFollowingData(url: url) { [weak self] result in
            switch result {
            case .success(let listOf):
                self?.delegate?.receiveFollowingData(listOf)
            case .failure(let error):
                print("Error processing json data: \(error.localizedDescription)")
            }
        }
    }
}

