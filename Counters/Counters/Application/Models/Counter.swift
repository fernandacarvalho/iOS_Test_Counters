//
//  Counter.swift
//  Counters
//
//  Created by Fernanda FC. Carvalho on 19/06/21.
//

import Foundation

class Counter: NSObject, Codable {
    var title: String?
    var id: String?
    var count: Int?
    
    init(title: String, id: String, count: Int) {
        self.title = title
        self.id = id
        self.count = count
    }
}
