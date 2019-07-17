//----------------------------------------------------------------------------------
//  File Name         :  AlamofireClient
//  Description       :  Manager for Client Requests - GET, POST, PATCH & DELETE
//                    :  1. ClientProtocol - Request method with Endpoint
//                       2. Manages requests and response from server
//  Author            :  Rathish Kannan
//  E-mail            :  rathishnk@hotmail.co.in
//  Dated             :  26th May 2019
//  Copyright (c) 2018 Rathish Kannan All rights reserved.
//-----------------------------------------------------------------------------------


import Foundation
import Alamofire

//API Response Type Enum
enum XResults<T>{
    case Success(result: T)
    case Failure(error: XErrorType)
}

// MARK: - SError
enum XErrorCodes: String{
    case OK
    case ERROR
    case UNAUTHORISED
}

// MARK: - SError
enum XErrorType: Equatable, Error{
    case CannotFetch(String)
    case CannotCreate(String)
    case CannotUpdate(String)
    case CannotDelete(String)
}

// MARK: completionHandler
typealias AlamofireCompletionHandler = (XResults<DataResponse<Data>>) -> Void

protocol ClientProtocol {
    /// request
    ///
    /// - Parameters:
    ///   - endpoint: Endpoint - type of request, path and headers, result - decodable object
    ///   - completionHandler: AlamofireCompletionHandler
    func request<DataRequest>(_ endpoint: Endpoint<DataRequest>, completionHandler: @escaping AlamofireCompletionHandler)
}

@objc public class AlamofireClient:NSObject, ClientProtocol {
    private let manager: Alamofire.SessionManager
    
    let headers: HTTPHeaders = [
        "Accept": "application/json",
        "Content-Type" :"application/json"
    ]

    static let shared = AlamofireClient()

    private class Config {
        var authToken:String?
        var baseURLString:String = ""
    }
    
    private static let config = Config()
    
    /**
     setup - required to intialised to use AlamofireClient
     - - -

     ## Usage:  AlamofireClient.setup(token: "")
     - - -
     - parameters:
     - token: The Auth token for API Server
     - baseURL: The URL with domain and path,until ?
     
     description:
     - token: default: nil
     - baseURL: default:fake API for mytaxi
     */
    @objc class func setup(token:String, baseURL: String = "https://fake-poi-api.mytaxi.com/"){
        AlamofireClient.config.authToken = token
        AlamofireClient.config.baseURLString = baseURL
    }
    
    /// Base
    ///
    /// - Parameter path: url String
    /// - Returns:      - baseURL: default:fake API for mytaxi
    private func url(path: Path) -> URL {
        let urlStr = path.addingPercentEncoding(withAllowedCharacters:CharacterSet.urlQueryAllowed) ?? ""
        guard let url = URL(string: AlamofireClient.config.baseURLString + urlStr) else { fatalError("baseURL could not be configured.")}
        return url
    }
    
    private override init() {
        guard let param = AlamofireClient.config.authToken else {
            fatalError("Error - you must call setup before accessing MySingleton.shared")
        }
        
        var defaultHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        defaultHeaders["Authorization"] = "Bearer \(param)"
        
        let configuration = URLSessionConfiguration.default
        
        // Add `Auth` header to the default HTTP headers set by `Alamofire`
        /*configuration.httpAdditionalHeaders = defaultHeaders*/
        
        self.manager = Alamofire.SessionManager(configuration: configuration)
        self.manager.retrier = OAuth2Retrier()
    }
    
    /// Usage : FilterListViewController.fetchFilters()
    ///
    /// - Parameters:
    ///   - endpoint: Endpoint - method, path, headers & result data
    ///   - completionHandler: AlamofireCompletionHandler - Data
    func request<DataRequest>(_ endpoint: Endpoint<DataRequest>, completionHandler: @escaping AlamofireCompletionHandler) {
        let request = self.manager.request(
            self.url(path: endpoint.path),
            method: httpMethod(from: endpoint.method),
            parameters: endpoint.parameters,
            encoding: URLEncoding.queryString,
            headers: self.headers
        )
        request
            .validate()
            .responseData() { response in
                let result = response.result.flatMap(endpoint.decode)
                switch result {
                case .success(_):
                    completionHandler(XResults.Success(result:response))
                case let .failure(err):
                    completionHandler(XResults.Failure(error: XErrorType.CannotFetch(err.localizedDescription)))
                    print(err)
                }
        }
    }
}

private func httpMethod(from method: Method) -> Alamofire.HTTPMethod {
    switch method {
    case .get: return .get
    case .post: return .post
    case .put: return .put
    case .patch: return .patch
    case .delete: return .delete
    }
}


private class OAuth2Retrier: Alamofire.RequestRetrier {
    func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
        if (error as? AFError)?.responseCode == 401 {
            // TODO: implement your Auth2 refresh flow
            // See https://github.com/Alamofire/Alamofire#adapting-and-retrying-requests
        }
        completion(false, 0)
    }
}

extension JSONDecoder {
    func decodeResponse<T: Decodable>(from response: DataResponse<Data>) -> Result<T> {
        guard response.error == nil else {
            print(response.error!)
            return .failure(response.error!)
        }
        
        guard let responseData = response.data else {
            print("didn't get any data from API")
            return .failure(XErrorType.CannotCreate("Prsing failed"))
        }
        do {
            let item = try decode(T.self, from: responseData)
            return .success(item)
        } catch {
            print("error trying to decode response")
            print(error)
            return .failure(error)
        }
    }
}

//API Function to be Extended
enum API {}

extension API {
    //https://fake-poi-api.mytaxi.com/?p2Lat=53.394655&p1Lon=-65.757589&p1Lat=59.694865&p2Lon=10.099891
    static func fetch(request:List.Fetch.Request ) -> Endpoint<Categories> {
        return Endpoint(path: "p2Lat=\(request.p2Lat)&p1Lon=\(request.p1Lon)&p1Lat=\(request.p1Lat)&p2Lon=\(request.p2Lon)")
    }
    
}
 
 
