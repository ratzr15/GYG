//---------------------------------------------------------------------------------------------------------------------------------------
//  File Name        :   Router
//  Description      :   Navigation logics from the categories to other pages
//                       2. Architecture    - TDD + Clean Swift (http://clean-swift.com)
//  Author            :  Rathish Kannan
//  E-mail            :  rathishnk@hotmail.co.in
//  Dated             :  28th May 2019
//  Copyright (c) 2019-20 Rathish Kannan. All rights reserved.
//----------------------------------------------------------------------------------------------------------------------------------------


import UIKit

@objc protocol RoutingLogic{

}

protocol DataPassing{
  var dataStore: DataStore? { get }
}

class Router: NSObject, RoutingLogic, DataPassing{
  weak var viewController: ViewController?
  var dataStore: DataStore?
  
}
