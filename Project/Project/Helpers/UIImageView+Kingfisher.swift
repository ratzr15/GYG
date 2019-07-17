//
//  UIImageView+Kingfisher.swift
//  SSSApp
//
//  Created by Rathish Kannan on 6/26/19.
//  Copyright © 2019 ExampleCompany. All rights reserved.
//

import Foundation
import Kingfisher

extension UIImageView {
    
    // base load func
     func load(_ url: URL?,
                      placeholder: String = defaultPlaceholder,
                      errorPlaceholder: String = defaultPlaceholder,
                      options: KingfisherOptionsInfo = defaultOptions) {
        
        // load place holder
        let p = UIImage(named: placeholder)
        
        // error place holder
        let e = UIImage(named: errorPlaceholder)
       
        // load image now
        self.kf.setImage(with: url, placeholder: p, options: options, progressBlock: nil) { result in
            // `result` is either a `.success(RetrieveImageResult)` or a `.failure(KingfisherError)`
            switch result {
            case .success(let value):
                // The image was set to image view:
                print(value.image)
                
                // From where the image was retrieved:
                // - .none - Just downloaded.
                // - .memory - Got from memory cache.
                // - .disk - Got from disk cache.
                print(value.cacheType)
                
                // The source object which contains information like `url`.
                print(value.source)
                
            case .failure(let error):
                self.image = e
                print(error) // The error happens
            }
        }
    }
}

public let defaultOptions: KingfisherOptionsInfo = [
    .scaleFactor(UIScreen.main.scale),
    .transition(.none),
    .cacheOriginalImage
]

public let defaultPlaceholder = "placeholder"
