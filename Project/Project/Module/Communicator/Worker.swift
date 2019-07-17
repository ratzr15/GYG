//---------------------------------------------------------------------------------------------------------------------------------------
//  File Name        :   CategoriesPresenter
//  Description      :   API/ store manager that resolves data
//                       2. Architecture    - TDD + Clean Swift (http://clean-swift.com)
//  Author            :  Rathish Kannan
//  E-mail            :  rathishnk@hotmail.co.in
//  Dated             :  28th May 2019
//  Copyright (c) 2019-20 Rathish Kannan. All rights reserved.
//----------------------------------------------------------------------------------------------------------------------------------------

import UIKit
import Alamofire

class Worker{
    var datas = Array<Categories>()
    var onCompletion:((_ results: [Categories]) -> Void)?
    
    
    func fetchData(request:List.Fetch.Request, completionHandler: @escaping ([Categories]) -> Void){
        
        AlamofireClient.setup(token: "", baseURL: "https://fake-poi-api.mytaxi.com/?")

        _ = AlamofireClient.shared.request(API.fetch(request: request)){ results in
            switch (results) {
            case .Success(let aggregations):
                let decoder = JSONDecoder()
                let codable: Result<Categories> = decoder.decodeResponse(from: aggregations)
                guard let cats = codable.value  else {
                    completionHandler([])
                    return
                }
                completionHandler([cats])
            case .Failure:
                print("Failure  ❌")
                completionHandler([])
            }
        }
        
        
    }
}

