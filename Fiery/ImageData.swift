//
//  ImageData.swift
//  Fiery
//
//  Created by James Harquail on 2016-06-01.
//  Copyright © 2016 Ragnar Development. All rights reserved.
//

struct ImageData {
    
    var url: String?
    var ref: String?
    
    private static let _imageUrl = "url"
    private static let _imageRef = "ref"
    
    private func valid() -> Bool {
        return url != nil && ref != nil
    }
    
    func dataFormat() -> [String: AnyObject]? {
        
        if !valid() {
            return nil
        }
        
        var returnData = [String: AnyObject]()
        returnData[ImageData._imageUrl] = url
        returnData[ImageData._imageRef] = ref
        
        return returnData
    }
    
    init(url: String?, ref: String?) {
        self.url = url
        self.ref = ref
    }
    
    init(data: [String: AnyObject]?) {
        
        if let url = data?[ImageData._imageUrl] as? String, let ref = data?[ImageData._imageRef] as? String {
            self.init(url: url, ref: ref)
            return
        }
        
        self.init(url: nil, ref: nil)
    }
}