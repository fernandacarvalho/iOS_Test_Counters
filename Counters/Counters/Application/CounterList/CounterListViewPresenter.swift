//
//  CounterListViewPresenter.swift
//  Counters
//
//  Created by Fernanda FC. Carvalho on 19/06/21.
//

import Foundation

internal final class CounterListViewPresenter {
    private let counters: [Counter] = [
        Counter(title: "teste 1", id: "1", count: 0),
        Counter(title: "teste 2", id: "1", count: 2),
        Counter(title: "teste 3", id: "1", count: 6),
        Counter(title: "teste 4", id: "1", count: 3),
        Counter(title: "teste 5", id: "1", count: 7),
        Counter(title: "teste 6", id: "1", count: 0),
        Counter(title: "teste 6", id: "1", count: 0),
        Counter(title: "teste 8", id: "1", count: 4),
        Counter(title: "teste 9", id: "1", count: 2),
        Counter(title: "teste 10", id: "1", count: 0),
        Counter(title: "teste 11", id: "1", count: 0),
        Counter(title: "teste 12", id: "1", count: 5)
    ]
}
extension CounterListViewPresenter: CountersListViewControllerPresenter {
    var viewModel: CountersListView.ViewModel {
        return .init(counters: self.counters)
    }
}
