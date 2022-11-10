//
//  UserDefault+Extension.swift
//  Utility
//
//  Created by Decagon on 10/11/2022.
//

import Foundation
import APIModels

 extension UserDefaults {
  public enum UserDefaultKey: String {
        case gitUserData
        case favouritesData
    }
    
     public var offlineUsers: APIModels.GitDataModel? {
        get {
            get(key: UserDefaultKey.gitUserData.rawValue, type: APIModels.GitDataModel.self)
        }
        set {
            set(key: UserDefaultKey.gitUserData.rawValue, newValue: newValue, type: APIModels.GitDataModel.self)
        }
    }
    
     public var favourites: [APIModels.Item]? {
        get {
            get(key: UserDefaultKey.favouritesData.rawValue, type: [APIModels.Item].self)
        }
        set {
            set(key: UserDefaultKey.favouritesData.rawValue, newValue: newValue, type: [APIModels.Item].self)
        }
    }
    
        private func get<T: Codable>(key: String, type: T.Type) -> T? {
            if let savedData = object(forKey: key) as? Data {
                do {
                    return try JSONDecoder().decode(T.self, from: savedData)
                } catch {
                    print(error)
                    return nil
                }
            }
            return nil
        }
        
        private func set<T: Codable>(key: String, newValue: T?, type: T.Type) {
            if newValue == nil {
                removeObject(forKey: key)
                return
            }
            do {
                let encoded: Data = try JSONEncoder().encode(newValue)
                set(encoded, forKey: key)
            } catch {
                print(error)
            }
        }
    }

extension Array where Element: Hashable {
    public func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()

        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }

    public mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}
