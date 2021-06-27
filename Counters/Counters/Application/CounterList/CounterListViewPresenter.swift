//
//  CounterListViewPresenter.swift
//  Counters
//
//  Created by Fernanda FC. Carvalho on 19/06/21.
//

import Foundation

public enum CounterListPlaceholderAction {
    case createCounter
    case getCounters
    case none
}

protocol CounterListViewPresenterDelegate: AnyObject {
    func refreshList()
    func createCounter()
    func getCountersSuccess()
    func getCountersError(baseResponse: BaseResponse)
    func showPlaceholder(withTitle title: String, subtitle: String, btnTitle: String)
    func hidePlaceholder()
}

final class CounterListViewPresenter {
    
    private(set) var counters: [Counter] = [Counter]()
    weak var delegate: CounterListViewPresenterDelegate?
    private let service: CountersListService
    private var placeholderAction: CounterListPlaceholderAction = .none
    
    init(delegate: CounterListViewPresenterDelegate, service: CountersListService = CountersListService()) {
        self.delegate = delegate
        self.service = service
    }
    
    func getListFromServer() {
        self.service.getCounters { [weak self] response in
            guard let selfObj = self else { return }
            switch response {
            case .success(let counters):
                selfObj.counters = counters
                selfObj.delegate?.getCountersSuccess()
                selfObj.checkEmptyCountersList()
            case .failure(let error):
                selfObj.delegate?.getCountersError(baseResponse: error)
                selfObj.showRetryPlaceholder(error: error)
                break
            }
        }
    }
    
    func placeholderButtonClicked() {
        switch self.placeholderAction {
        case .getCounters:
            self.delegate?.refreshList()
        case .createCounter:
            self.delegate?.createCounter()
        default:
            break
        }
    }
}

private extension CounterListViewPresenter {
    func checkEmptyCountersList() {
        if self.counters.count == 0 {
            self.showNoCountersPlaceholder()
        }
    }
    
    func showNoCountersPlaceholder() {
        self.placeholderAction = .createCounter
        self.delegate?.showPlaceholder(
            withTitle: NSLocalizedString("NO_COUNTERS", comment: ""),
            subtitle: "",
            btnTitle: NSLocalizedString("BTN_CREATE_COUNTER", comment: ""))
    }
    
    func showRetryPlaceholder(error: BaseResponse) {
        self.placeholderAction = .getCounters
        self.delegate?.showPlaceholder(
            withTitle: error.title,
            subtitle: error.message,
            btnTitle:  NSLocalizedString("RETRY", comment: ""))
    }
}
