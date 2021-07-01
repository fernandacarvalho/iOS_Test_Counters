//
//  UtilUrlConfig.swift
//  Counters
//
//  Created by Fernanda FC. Carvalho on 01/07/21.
//

import Foundation

public enum BuildConfiguration {
    enum Error: Swift.Error {
        case missingKey, invalidValue
    }
    
    static func value<T>(for key: String) throws -> T where T: LosslessStringConvertible {
        guard let object = Bundle.main.object(forInfoDictionaryKey: key) else {
            throw Error.missingKey
        }
        
        switch object {
        case let string as String:
            guard let value = T(string) else { fallthrough }
            return value
        default:
            throw Error.invalidValue
        }
    }
}

private enum API {
    static var backendURL: String {
        do {
            return try BuildConfiguration.value(for: "BASE_URL")
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}

private let data = UtilUrlConfig()

class UtilUrlConfig: NSObject {
    
    class var sharedInstance : UtilUrlConfig {
        return data
    }
    
    var apiBaseUrl: String {
        get {
            return API.backendURL
        }
    }
    
    override init() {
        super.init()
    }
}

