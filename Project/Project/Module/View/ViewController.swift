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

protocol DisplayLogic: class{
    func displayFetchedData(viewModel: List.Fetch.ViewModel)
}

class ViewController: UIViewController, DisplayLogic {
  var interactor: FetchDataBusinessLogic?
  var router: (NSObjectProtocol & RoutingLogic & DataPassing)?
  var items: [ListViewModelItem] = []
    
  fileprivate var request = List.Fetch.Request.init(count: "10", page: 1, rating: "0..5", sortBy: "", direction: "asc")

  @IBOutlet weak var tableView: UITableView!
    
    /// Mode of View
    ///
    /// - list: Intial screen with list of resources
    /// - detail: detail of selected resource
    enum Mode {
        case list,detail
    }
    
    var mode:Mode = .list
    
    // MARK: Object lifecycle
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?){
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    setUp()
  }

  required init?(coder aDecoder: NSCoder){
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
        setSortButtons()
        setUpTableView()
        fetchData(request: request)
  }
    
  private func setUpTableView(){
        tableView?.register(NamePictureCell.nib, forCellReuseIdentifier: NamePictureCell.identifier)
        tableView?.dataSource = self
  }

  private func clearNavigation(){
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = UIColor.black
  }
    
  private func setSortButtons(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "sort"), style:  .plain, target: self, action: #selector(sort))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "rate"), style: .plain, target: self, action: #selector(rating))
    }
    
  @objc func sort() {
    self.request.sortBy = "date_of_review"
    self.request.direction =  self.request.direction == "asc" ? "desc" : "asc"
    self.request.count = String(items.count)
    fetchData(request: self.request)
  }

  @objc func rating() {
    self.request.sortBy = "rating"
    self.request.direction =  self.request.direction == "asc" ? "desc" : "asc"
    self.request.count = String(items.count)
    fetchData(request: self.request)
  }

    // MARK: Setup Functions

  func fetchData(request:List.Fetch.Request? = nil){
        if let req = request {
            interactor?.fetchData(request: req)
        }
  }

  func displayFetchedData(viewModel: List.Fetch.ViewModel){
        let vm =  viewModel.datas

        if self.request.sortBy == "" {
            for v in vm {
                items.append(v)
            }
        }else{
            request.sortBy = ""
            items.removeAll()
            for v in vm {
                items.append(v)
            }
        }
    
        if items.count == 0 {
            let noResult = NoResultsItem(name:"No Results found, please try again.")
            items.append(noResult)
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

//MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return  items.filter { $0.type == .list }.count > 0 ? items.filter { $0.type == .list }.first?.rowCount ?? 0 : items.filter { $0.type == .noResult }.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if mode == .detail {
            return items.filter { $0.type == .details }.count > 0 ? items.count : items.filter { $0.type == .noResult }[section].rowCount
        }else{
            return items.filter { $0.type == .list }.count > 0 ? items.count : items.filter { $0.type == .noResult }[section].rowCount
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items.filter { mode == .list ? $0.type == .list : $0.type == .details }[indexPath.row]
        switch item.type {
        case .details:
            return UITableViewCell()
        case .list:
            if let cell = tableView.dequeueReusableCell(withIdentifier: NamePictureCell.identifier, for: indexPath) as? NamePictureCell {
                cell.item = item
                return cell
            }
            return UITableViewCell()
        case .noResult:
            return UITableViewCell()
        }
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return items[section].type == .list ? "" : items[section].sectionTitle
    }
}


extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastElement = items.count - 1
        if indexPath.row == lastElement && items.count > 0 && request.sortBy == "" {
            self.request.page = self.request.page + 1
            fetchData(request: self.request)
        }

    }

}
