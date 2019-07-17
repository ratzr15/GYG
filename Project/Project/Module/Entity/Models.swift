//---------------------------------------------------------------------------------------------------------------------------------------
//  File Name        :   Models
//  Description      :   VM's resolved as Equatables
//                       2. Architecture    - TDD + Clean Swift (http://clean-swift.com)
//  Author            :  Rathish Kannan
//  E-mail            :  rathishnk@hotmail.co.in
//  Dated             :  28th May 2019
//  Copyright (c) 2019-20 Rathish Kannan. All rights reserved.
//----------------------------------------------------------------------------------------------------------------------------------------

import UIKit
import MapKit

enum ListViewModelItemType {
    case list
    case details
    case noResult
}

protocol ListViewModelItem {
    var type: ListViewModelItemType { get }
    var sectionTitle: String { get }
    var rowCount: Int { get }
}

struct NoResultsItem: ListViewModelItem {
    var type: ListViewModelItemType {
        return .noResult
    }
    
    var sectionTitle: String {
        return self.name
    }
    
    var rowCount: Int {
        return 0
    }
    
    var name: String
    
    init(name: String) {
        self.name = name
    }
}



enum List{
    // MARK: Use cases    
    enum Fetch{
        
        struct Request{
            var count:String
            var page:String
            var rating:String
            var sortBy:String
            var direction:String
        }
        
        struct Response{
            var datas: [Datum]
        }
        
        struct ViewModel {
            class ListItem: NSObject, ListViewModelItem {
                var type: ListViewModelItemType {
                    return .list
                }
                
                var sectionTitle: String {
                    return "Reviews around Berlin!"
                }
                
                var rowCount: Int {
                    return 1
                }
                
                var rating: String?
                var title: String?
                var message: String?
                var author: String?
                var photo: String?

                init(rating: String? = nil, message: String? = nil, title: String? = nil,author: String? = nil, photo: String? = nil) {
                    self.rating = rating
                    self.message = message
                    self.title = title
                    self.author = author
                    self.photo = photo
                }
            }
            var datas: [ListItem]            
        }
        
        

    }
}


