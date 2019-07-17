//---------------------------------------------------------------------------------------------------------------------------------------
//  File Name        :   ViewController
//  Description      :   Controller to manange the datas from data store
//                   :   1. UI    - link to UI
//                       2. Architecture    - TDD + Clean Swift (http://clean-swift.com)
//  Author            :  Rathish Kannan
//  E-mail            :  rathishnk@hotmail.co.in
//  Dated             :  27th May 2019
//  Copyright (c) 2019-20 Rathish Kannan. All rights reserved.
//----------------------------------------------------------------------------------------------------------------------------------------

import UIKit
import MapKit

protocol DisplayLogic: class{
    func displayFetchedData(viewModel: List.Fetch.ViewModel)
}

class ViewController: UIViewController, DisplayLogic {

    var interactor: FetchDataBusinessLogic?
    var router: (NSObjectProtocol & RoutingLogic & DataPassing)?
    
    /// Mode of View
    ///
    /// - list: Intial screen with list of resources
    /// - detail: detail of selected resource
    enum Mode {
        case list,detail
    }
    
    var mode:Mode = .detail{
        didSet {
            setUp()
        }
    }
    
    var items: [ListViewModelItem] = []

    // MARK: Object lifecycle

  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?){
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    setUp()
  }

  required init?(coder aDecoder: NSCoder)
  {
    super.init(coder: aDecoder)
    setUp()
  }

  // MARK: Setup

  private func setUp(){
        let viewController        = self
        let interactor            = Interactor()
        let presenter             = Presenter()
        let router                = Router()
        viewController.interactor = interactor
        viewController.router     = router
        interactor.presenter      = presenter
        presenter.viewController  = viewController
        router.viewController     = viewController
        router.dataStore          = interactor    
  }

  // MARK: View lifecycle

    override func viewDidLoad(){
        super.viewDidLoad()
        clearNavigation()
        fetchData(request: List.Fetch.Request.init(count: "10", page: "1", rating: "0..5", sortBy: "date_of_review", direction: "DESC"))
    }
    
    private func clearNavigation(){
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    // MARK: Setup Functions

    func fetchData(request:List.Fetch.Request? = nil){
        if let req = request {
            interactor?.fetchData(request: req)
        }
    }

    func displayFetchedData(viewModel: List.Fetch.ViewModel){
        let vm =  viewModel.datas
        items = vm
        if items.count == 0 {
            let noResult = NoResultsItem(name:"No Results found, please try again.")
            items.append(noResult)
        }
    }
}
