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
    func showPlaceholder(withTitle title: String, subtitle: String, btnTitle: String)
    func hidePlaceholder()
    func showAlert(withTitle title: String, andMessage message: String)
    func getCountersSuccess()
    func getCountersError()
    func increaseCounterSuccess()
    func increaseCounterError()
    func decreaseCounterSuccess()
    func decreaseCounterError()
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
                selfObj.delegate?.getCountersError()
                selfObj.showRetryPlaceholder(error: error)
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
    
    func decreaseBtnClicked(counter: Counter) {
        guard let id = counter.id else {
            self.delegate?.decreaseCounterError()
            return
        }
        self.service.decreaseCounter(counterId: "\(id)") { [weak self] response in
            guard let selfObj = self else { return }
            switch response {
            case .success(let counters):
                selfObj.counters = counters
                selfObj.delegate?.decreaseCounterSuccess()
            case .failure(let error):
                selfObj.delegate?.decreaseCounterError()
                selfObj.delegate?.showAlert(withTitle: error.title, andMessage: error.message)
            }
        }
    }
    
    func increaseBtnClicked(counter: Counter) {
        guard let id = counter.id else {
            self.delegate?.increaseCounterError()
            return
        }
        self.service.increaseCounter(counterId: "\(id)") { [weak self] response in
            guard let selfObj = self else { return }
            switch response {
            case .success(let counters):
                selfObj.counters = counters
                selfObj.delegate?.increaseCounterSuccess()
            case .failure(let error):
                selfObj.delegate?.increaseCounterError()
                selfObj.delegate?.showAlert(withTitle: error.title, andMessage: error.message)
            }
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
