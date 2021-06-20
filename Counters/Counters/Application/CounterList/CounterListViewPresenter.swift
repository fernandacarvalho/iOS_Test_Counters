//
//  CounterListViewPresenter.swift
//  Counters
//
//  Created by Fernanda FC. Carvalho on 19/06/21.
//

import Foundation

protocol CounterListViewPresenterDelegate: AnyObject {
    func didUpdateViewModel()
    func getCountersError(baseResponse: BaseResponse)
}

internal final class CounterListViewPresenter {
    private var counters: [Counter] = [Counter]() {
        didSet {
            self.delegate?.didUpdateViewModel()
        }
    }
    weak var delegate: CounterListViewPresenterDelegate?
    private let service = CountersListService()
    
    func getViewModel() -> CounterListViewModel? {
        return CounterListViewModel(counters: self.counters)
    }
    
    func test() {
        let counter = Counter(title: "HELLO", id: "1", count: 20)
        self.counters.append(counter)
    }
    
    func getListFromServer() {
        self.service.getCounters { [unowned self] response in
            switch response {
            case .success(let counters):
                self.counters = counters
            case .failure(let error):
                self.delegate?.getCountersError(baseResponse: error)
                break
            }
        }
    }
}


