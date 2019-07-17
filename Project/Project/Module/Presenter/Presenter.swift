//---------------------------------------------------------------------------------------------------------------------------------------
//  File Name        :   CategoriesPresenter
//  Description      :   Presenter to manange the categories from data store
//                   :   1. UI    - https://github.com/ratzr15/mobile-test/blob/master/resources_android.png
//                       2. Architecture    - TDD + Clean Swift (http://clean-swift.com)
//  Author            :  Rathish Kannan
//  E-mail            :  rathishnk@hotmail.co.in
//  Dated             :  28th May 2019
//  Copyright (c) 2019-20 Rathish Kannan. All rights reserved.
//----------------------------------------------------------------------------------------------------------------------------------------

import UIKit

protocol DataPresentationLogic{
    func presentData(response: List.Fetch.Response)
}

class Presenter: DataPresentationLogic{
    weak var viewController: DisplayLogic?
    
    // MARK: Present to View

    func presentData(response: List.Fetch.Response){
        var displayedData: [List.Fetch.ViewModel.ListItem] = []
        
        if response.datas.count > 0 {
            for _ in response.datas {
                let listVM = List.Fetch.ViewModel.ListItem.init(latitude: 1.00, longitude: 2.00, title:"category.fleetType.value" )
                displayedData.append(listVM)
            }
        }
        
        let viewModel = List.Fetch.ViewModel(datas: displayedData)
        viewController?.displayFetchedData(viewModel: viewModel)

    }
    
    
    
    
}
