//
//  UtilUrlFactory.swift
//  Counters
//
//  Created by Fernanda FC. Carvalho on 20/06/21.
//

import Foundation

class UtilUrlFactory {
    static let baseUrl = "http://127.0.0.1:3000/api/v1"
    
    class CountersList {
        class func countersUrl() -> String {
            return UtilUrlFactory.baseUrl + "/counters"
        }
        
        class func counterUrl() -> String {
            return UtilUrlFactory.baseUrl + "/counter"
        }
        
        class func decreaseCounterUrl() -> String {
            return UtilUrlFactory.baseUrl + "/counter/dec"
        }
        
        class func increaseCounterUrl() -> String {
            return UtilUrlFactory.baseUrl + "/counter/inc"
        }
    }
}
