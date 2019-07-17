//----------------------------------------------------------------------------------
//  File Name         :  AlamofireClient
//  Description       :  Manager for Client Requests - GET, POST, PATCH & DELETE
//                    :  1. ClientProtocol - Request method with Endpoint
//                       2. Manages requests and response from server
//  Author            :  Rathish Kannan
//  Dated             :  26th May 2019
//  Copyright (c) 2018 Rathish. All rights reserved.
//-----------------------------------------------------------------------------------

import Foundation


// MARK: Defines

typealias Parameters = [String: Any]
typealias Path = String

enum Method {
    case get, post, put, patch, delete
}


// MARK: Endpoint


final class Endpoint<Response>:NSObject {
    let method: Method
    let path: Path
    let parameters: Parameters?
    let decode: (Data) throws -> Response

    init(method: Method = .get,
         path: Path,
         parameters: Parameters? = nil,
         decode: @escaping (Data) throws -> Response) {
        self.method = method
        self.path = path
        self.parameters = parameters
        self.decode = decode
    }
}


// MARK: Convenience

extension Endpoint where Response: Swift.Decodable {
    convenience init(method: Method = .get,
                     path: Path,
                     parameters: Parameters? = nil) {
        self.init(method: method, path: path, parameters: parameters) {
            try JSONDecoder().decode(Response.self, from: $0)
        }
    }
}

extension Endpoint where Response == Void {
    convenience init(method: Method = .get,
                     path: Path,
                     parameters: Parameters? = nil) {
        self.init(
            method: method,
            path: path,
            parameters: parameters,
            decode: { _ in () }
        )
    }
}
