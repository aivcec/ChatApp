//
//  Extensions.swift
//  ChatApp
//
//  Created by Antonio Ivcec on 22/8/18.
//  Copyright © 2018 Antonio Ivcec. All rights reserved.
//

import UIKit

let imageCache: NSCache = NSCache<NSString, UIImage>()

extension UIImageView {
    
    func loadImageUsingCacheWithUrlString(urlString: String) {
        
        image = nil
        
        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
            image = cachedImage
        } else if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print(error)
                    return
                }
                
                if let data = data, let downloadedImage = UIImage(data: data)  {
                    imageCache.setObject(downloadedImage, forKey: urlString as NSString)
                    DispatchQueue.main.async {
                        self.image = UIImage(data: data)
                    }
                }
                }.resume()
        }
    }
}
