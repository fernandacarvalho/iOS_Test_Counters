//
//  CounterListViewModel.swift
//  Counters
//
//  Created by Fernanda FC. Carvalho on 19/06/21.
//

import Foundation



class CounterListViewModel: NSObject {
    var counters: [Counter]?
    
    init(counters: [Counter]){
        self.counters = counters
    }
    
}
