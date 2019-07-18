//---------------------------------------------------------------------------------------------------------------------------------------
//  File Name        :   Worker
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
    var datas = Array<Datum>()
    var onCompletion:((_ results: [Datum]) -> Void)?
    
    
    func fetchData(request:List.Fetch.Request, completionHandler: @escaping ([Datum]) -> Void){
        
        AlamofireClient.setup(token: "", baseURL: "https://www.getyourguide.com/berlin-l17/tempelhof-2-hour-airport-history-tour-berlin-airlift-more-t23776/reviews.json?")

        _ = AlamofireClient.shared.request(API.fetch(request: request)){ results in
            switch (results) {
            case .Success(let aggregations):
                let decoder = JSONDecoder()
                let codable: Result<Review> = decoder.decodeResponse(from: aggregations)
                guard let cats = codable.value  else {
                    completionHandler([])
                    return
                }
                completionHandler(cats.data)
            case .Failure:
                print("Failure  ❌")
                completionHandler([])
            }
        }
        
        
    }
}

