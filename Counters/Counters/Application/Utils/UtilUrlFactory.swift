//
//  UtilUrlFactory.swift
//  Counters
//
//  Created by Fernanda FC. Carvalho on 20/06/21.
//

import Foundation

class UtilUrlFactory {
    static let baseUrl = UtilUrlConfig.sharedInstance.apiBaseUrl
    
    class CountersList {
        class func countersUrl() -> String {
            return UtilUrlFactory.baseUrl + "/counters"
        }
        
        class func decreaseCounterUrl() -> String {
            return UtilUrlFactory.baseUrl + "/counter/dec"
        }
        
        class func increaseCounterUrl() -> String {
            return UtilUrlFactory.baseUrl + "/counter/inc"
        }
        
        class func deleteCounterUrl() -> String {
            return UtilUrlFactory.baseUrl + "/counter"
        }
    }
    
    class CreateCounter {
        class func counterUrl() -> String {
            return UtilUrlFactory.baseUrl + "/counter"
        }
    }
}
