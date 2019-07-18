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
            case .success(_):
                break
            case .failure(_):
                self.image = e
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
