//--------------------------------------------------------------------------------
//  File Name        :   InteractorTests
//  Description      :   Test for interactor to presenter
//                   :   1. UI    - {link to screenshot}
//  Author            :  Rathish Kannan
//  E-mail            :  rathishnk@hotmail.co.in
//  Dated             :  27th May 2019
//  Copyright (c) 2019-20 Rathish Kannan. All rights reserved.
//-----------------------------------------------------------------------------------


import XCTest
@testable import Project

class InteractorTests: XCTestCase
{
  // MARK: - Subject under test
  
  var sut: Interactor!
  
  // MARK: - Test lifecycle
  
  override func setUp()
  {
    super.setUp()
    setupInteractor()
  }
  
  override func tearDown()
  {
    super.tearDown()
  }
  
  // MARK: - Test setup
  
  func setupInteractor()
  {
    sut = Interactor()
  }
  
  // MARK: - Test doubles
  
  class PresentationLogicSpy: DataPresentationLogic
  {
    // MARK: Spied methods

    func presentData(response: List.Fetch.Response) {
        presentFetchRequestCalled = true

    }
    
    // MARK: Method call expectations
    
    var presentFetchRequestCalled = false
    
    
    
  }
  
  class WorkerSpy: Worker
  {
    // MARK: Method call expectations
    
    var fetchRequestCalled = false
    
    // MARK: Spied methods

    override func fetchData(request: List.Fetch.Request, completionHandler: @escaping ([Datum]) -> Void) {
        fetchRequestCalled = true
        completionHandler([])
    }
    
  }
  
  // MARK: - Tests
  
  func testFetchOrdersShouldAskOrdersWorkerToFetchOrdersAndPresenterToFormatResult()
  {
    // Given
    let listPresentationLogicSpy = PresentationLogicSpy()
    sut.presenter = listPresentationLogicSpy
    let workerSpy = WorkerSpy.init()
    let request = List.Fetch.Request.init(count: "10", page: 1, rating: "0..5", sortBy: "", direction: "asc")

    workerSpy.fetchData(request: request){ (reviews) -> Void in
         self.sut.datas  = reviews
    }
    
    // When
    sut.fetchData(request: request)
    
    // Then
    XCTAssert(workerSpy.fetchRequestCalled, "Fetch() should ask Worker to fetch reviews")
  }
}
