//--------------------------------------------------------------------------------
//  File Name        :   MapWorkerTests
//  Description      :   Logic tests
//                   :   1. UI    - {link to screenshot}
//  Author            :  Rathish Kannan
//  E-mail            :  rathishnk@hotmail.co.in
//  Dated             :  27th May 2019
//  Copyright (c) 2019-20 Rathish Kannan. All rights reserved.
//-----------------------------------------------------------------------------------


import XCTest
import Alamofire

@testable import Project

class WorkerTests: XCTestCase {

    static var sut: Worker!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        setUpWorker()
    }
    
    func setUpWorker(){
        WorkerTests.sut = Worker.init()
    }
    
    
    // MARK: - Test doubles
    
    class MemStoreSpy: Worker
    {
        // MARK: Method call expectations
        
        var fetchRequestCalled = false
        
        // MARK: Spied methods
        
        var onComplete:((_ results: [Datum]) -> Void)?

        override func fetchData(request: List.Fetch.Request, completionHandler: @escaping ([Datum]) -> Void) {
            fetchRequestCalled = true
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
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
                        
                        WorkerTests.sut.datas = cats.data
                        completionHandler(cats.data)
                    case .Failure:
                        print("Failure  ❌")
                        completionHandler([])
                    }
                }
            }
        }
    }
    
    // MARK: - Tests
    
    func testFetchRequestShouldReturnData(){

        // Given
        let categoryMemStoreSpy = MemStoreSpy.init()
        
        // When
        var fetchedData = [Datum]()
        let expect = expectation(description: "Wait for fetchedData() to return")
        
        let request = List.Fetch.Request.init(count: "10", page: 1, rating: "0..5", sortBy: "", direction: "asc")

        categoryMemStoreSpy.fetchData(request: request) { (cats) in
            fetchedData = cats
            expect.fulfill()
        }
    
        //Fake API response time is not ideal!
        waitForExpectations(timeout: 2.1)
        
        // Then
        XCTAssert(categoryMemStoreSpy.fetchRequestCalled, "Calling fetchedData() should ask the data store for a list of reviews")
        XCTAssertEqual(fetchedData.count, WorkerTests.sut.datas.count , "fetchedData() should return a list of reviews")
        for category in fetchedData {
            XCTAssert(WorkerTests.sut.datas.contains(category), "Fetched datas should match in the data store")
        }
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
