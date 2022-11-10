//
//  UIImage+Extension.swift
//  Utility
//
//  Created by Decagon on 10/11/2022.
//

import UIKit

extension UIImageView {
    var cache: NSCache<NSString, UIImage> { API.cache }
    
    public func downloadImage(from urlString: String) {
        
        let cachekey = NSString(string: urlString)
        if let image = cache.object(forKey: cachekey) {
            self.image = image
            return
        }
        guard let url = URL(string: urlString) else { return }
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            if let _ = error { return }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { return }
            guard let data = data else { return }
            guard let image = UIImage (data: data) else {
                dump("Error creating image from data:\(String(describing: error))")
                return
            }
            self.cache.setObject(image, forKey: cachekey)
            DispatchQueue.main.async { self.image = image}
        }
        task.resume()
    }
}
