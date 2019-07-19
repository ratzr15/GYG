//--------------------------------------------------------------------------------
//  File Name        :   MapPresenterTests
//  Description      :   Logic tests
//                   :   1. UI    - {link to screenshot}
//  Author            :  Rathish Kannan
//  E-mail            :  rathishnk@hotmail.co.in
//  Dated             :  27th May 2019
//  Copyright (c) 2019-20 Rathish Kannan. All rights reserved.
//-----------------------------------------------------------------------------------


import XCTest
@testable import Project

class PresenterTests: XCTestCase
{
  // MARK: - Subject under test
  
  var sut: Presenter!
  
  // MARK: - Test lifecycle
  
  override func setUp()
  {
    super.setUp()
    setUpDetailsPresenter()
  }
  
  override func tearDown()
  {
    super.tearDown()
  }
  
  // MARK: - Test setup
  
  func setUpDetailsPresenter()
  {
    sut = Presenter()
  }
  
  // MARK: - Test doubles
  

    // MARK: Spied methods

  class DisplayLogicSpy: DisplayLogic{
    
    // MARK: Argument expectations
    
    var viewModel: List.Fetch.ViewModel!
    
    
    // MARK: Method call expectations
    
    var displayFetchedDetailsCalled = false
    
    
    
    func displayFetchedData(viewModel: List.Fetch.ViewModel) {
        displayFetchedDetailsCalled = true
        self.viewModel = viewModel
        
    }
    

  }
  
  // MARK: - Tests
  
  func testPresentFetchedDetailsShouldFormatFetchedDetailsForDisplay()
  {
    // Given
    let displayLogicSpy = DisplayLogicSpy()
    sut.viewController = displayLogicSpy
    
    // When
    let details = Array<Datum>()
    let response = List.Fetch.Response(datas: details)
    sut.presentData(response: response)
    
    // Then
    let displayeDatas = displayLogicSpy.viewModel.datas
   
    for (index, displayedDetail) in displayeDatas.enumerated() {
      XCTAssertEqual(displayedDetail.sectionTitle, "details", "Presenting fetched detailss should properly format")
      XCTAssertEqual(displayedDetail.author, "reviewer", "Presenting fetched detailss should properly format")
        if index - 1 < displayeDatas.count {
            XCTAssertEqual(displayeDatas[index].id, displayeDatas[index + 1].id, "review ID's do not match, so no duplicates in VM's")
        }
    }
    
    
  }
  
  func testPresentFetchedDetailsShouldAskViewControllerToDisplayFetchedDetails()
  {
    // Given
    let detailsDisplayLogicSpy = DisplayLogicSpy()
    sut.viewController = detailsDisplayLogicSpy
    
    // When
    let details = Array<Datum>()
    let response = List.Fetch.Response(datas: details)
    sut.presentData(response: response)

    // Then
    XCTAssert(detailsDisplayLogicSpy.displayFetchedDetailsCalled, "Presenting fetched details should ask view controller to display them")
  }
}
