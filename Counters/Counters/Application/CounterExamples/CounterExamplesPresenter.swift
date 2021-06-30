//
//  CounterExamplesPresenter.swift
//  Counters
//
//  Created by Fernanda FC. Carvalho on 29/06/21.
//

import Foundation

protocol CounterExamplesPresenterProtocol {
    var viewModel: [CounterExample] { get }
}

internal final class CounterExamplesPresenter {
    
    private let drink: CounterExample =
        .init(
            type:  "Drinks",
            list: ["Cups of coffee", "Glasses of water", "Bottles of wine"]
        )
    
    private let food: CounterExample =
        .init(
            type: "Foods",
            list: ["Hot-dogs", "Cupcakes eaten", "Chicken", "Pizza"]
        )
    private let misc: CounterExample =
        .init(
            type: "Misc",
            list: ["Times sneezes", "Naps", "Day dreaming", "Parties"]
        )
}

extension CounterExamplesPresenter: CounterExamplesPresenterProtocol {
    var viewModel: [CounterExample] {
        return .init([
            drink,
            food,
            misc
        ])
    }
}
