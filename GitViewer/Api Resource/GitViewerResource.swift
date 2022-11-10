//
//  GitViewerResoucre.swift
//  GitViewer
//
//  Created by Decagon on 10/11/2022.
//

import UIKit
import GitViewerNetwork
import APIModels

protocol GitDataResourceProtocol{
    func getGitData(completion: @escaping(Result<APIModels.GitDataModel, UserError>) -> Void)
    func getFollowersData(url: String, completion: @escaping(Result<[APIModels.FollowDataModel], UserError>) -> Void)
    func getFollowingData(url: String, completion: @escaping(Result<[APIModels.FollowDataModel], UserError>) -> Void)
}

struct GitDataResource: GitDataResourceProtocol {
    private var httpUtility: UtilityService
    private var urlString: String
    
    public static let cache = NSCache<NSString, UIImage>()
    
    init(httpUtility: UtilityService = HTTPUtility(),
         urlString: String){
        self.httpUtility = httpUtility
        self.urlString = urlString
    }
    
    func getGitData(completion: @escaping(Result<APIModels.GitDataModel, UserError>) -> Void){
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.InvalidURL))
            return
        }
        
        httpUtility.performDataTask(url: url, resultType: APIModels.GitDataModel.self) { result in
            switch result {
            case .success(let jsonData):
                DispatchQueue.main.async {
                    completion(.success(jsonData))
                }
            case .failure(let error):
                completion(.failure(error))
            }
            
        }
    }
    
    func getFollowersData(url: String, completion: @escaping (Result<[APIModels.FollowDataModel], GitViewerNetwork.UserError>) -> Void) {
        guard let url = URL(string: url) else {
            completion(.failure(.InvalidURL))
            return
        }
        
        httpUtility.performDataTask(url: url, resultType: [APIModels.FollowDataModel].self) { result in
            switch result {
            case .success(let jsonData):
                DispatchQueue.main.async {
                    completion(.success(jsonData))
                }
            case .failure(let error):
                completion(.failure(error))
            }
            
        }
    }
    
    func getFollowingData(url: String, completion: @escaping (Result<[APIModels.FollowDataModel], GitViewerNetwork.UserError>) -> Void) {
        guard let url = URL(string: url) else {
            completion(.failure(.InvalidURL))
            return
        }
        
        httpUtility.performDataTask(url: url, resultType: [APIModels.FollowDataModel].self) { result in
            switch result {
            case .success(let jsonData):
                DispatchQueue.main.async {
                    completion(.success(jsonData))
                }
            case .failure(let error):
                completion(.failure(error))
            }
            
        }
    }
}

