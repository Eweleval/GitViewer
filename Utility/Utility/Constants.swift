//
//  Constants.swift
//  Utility
//
//  Created by Decagon on 10/11/2022.
//

import UIKit

public struct API {
    public static let baseUrl = "http://api.github.com"
    public static let path = "/search/users?"
    public static let param = "q=lagos&page="
    public static let cache = NSCache<NSString, UIImage>()
}

public struct Controller {
    public static let monitor = "Monitor"
    public static let title = "Git Users"
    public static let favTitle = "Favorites"
}

public struct Color {
    public static let backgroundColor = "myBackground"
    public static let titleColor = "myBlack"
}
