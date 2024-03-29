//---------------------------------------------------------------------------------------------------------------------------------------
//  File Name        :   CategoriesInteractor
//  Description      :   Median to request & recieve the data to UI
//                   :   1. UI    - link to UI
//                       2. Architecture    - TDD + Clean Swift (http://clean-swift.com)
//  Author            :  Rathish Kannan
//  E-mail            :  rathishnk@hotmail.co.in
//  Dated             :  27th May 2019
//  Copyright (c) 2019-20 Rathish Kannan. All rights reserved.
//----------------------------------------------------------------------------------------------------------------------------------------

import UIKit

protocol FetchDataBusinessLogic{
    func fetchData(request: List.Fetch.Request)
}

protocol DataStore{
    var datas: [Datum]? { get }
}

class Interactor: FetchDataBusinessLogic, DataStore{
    var datas: [Datum]?
    var presenter: DataPresentationLogic?
    var worker: Worker?
    
    func fetchData(request: List.Fetch.Request) {
        worker = Worker()
        worker?.fetchData(request: request){ (datas) -> Void in
            self.datas = datas
            let response = List.Fetch.Response(datas: datas)
            self.presenter?.presentData(response: response)
        }
    }
}
