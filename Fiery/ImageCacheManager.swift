//
//  ImageCacheManager.swift
//  Fiery
//
//  Created by James Harquail on 2016-05-28.
//  Copyright © 2016 Ragnar Development. All rights reserved.
//

import UIKit
import Haneke

class ImageCacheManager {

    typealias ImageResponseBlock = (image: UIImage?) -> Void
    
    private static func imageCache() -> Cache<UIImage> {
        return Shared.imageCache
    }
    
    static func clearImageCache() {
        imageCache().removeAll()
    }

    static func fetchImageWithUrl(url: NSURL?, response: ImageResponseBlock) {
        
        if url == nil {
            print("ImageCacheManager | Url is null")
            response(image: nil)
            return
        }
        
        imageCache().fetch(URL: url!).onSuccess { (image) in
            
            response(image: image)
            
        }.onFailure { (error) in
            if error != nil {
                print("ImageCacheManager | Error Fetching Image | " + error!.localizedDescription)
            }
            response(image: nil)
            return
        }
    }
    
    static func fetchUserImage(user: User?, response: ImageResponseBlock) {
        
        fetchImageWithUrl(user?.imageUrl(), response: response)
    }
}
