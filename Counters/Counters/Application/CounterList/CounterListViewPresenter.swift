//
//  CounterListViewPresenter.swift
//  Counters
//
//  Created by Fernanda FC. Carvalho on 19/06/21.
//

import Foundation
import UIKit

public enum CounterListPlaceholderAction {
    case createCounter
    case getCounters
    case none
}

protocol CounterListViewPresenterDelegate: AnyObject {
    func refreshList()
    func goToCreateCounter()
    func showPlaceholder(withTitle title: String, subtitle: String, btnTitle: String)
    func showAlert(withTitle title: String, andMessage message: String)
    func stopLoading()
    func getCountersSuccess()
    func increaseCounterSuccess()
    func decreaseCounterSuccess()
    func updateBottomViewWith(leftButtonEnabled: Bool, rightButtonIcon: UIImage, totalItems: String, totalCounts: String)
    func updateNavigationBar()
}

final class CounterListViewPresenter {
    
    private(set) var isEditionMode: Bool = false {
        didSet {
            self.updateCounts()
        }
    }
    private(set) var isEditionAvailable: Bool = false {
        didSet {
            self.delegate?.updateNavigationBar()
        }
    }
    private(set) var counters: [Counter] = [Counter]()
    private weak var delegate: CounterListViewPresenterDelegate?
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
                selfObj.updateCounts()
            case .failure(let error):
                selfObj.delegate?.stopLoading()
                selfObj.showRetryPlaceholder(error: error)
                selfObj.updateCounts()
            }
        }
    }
    
    func placeholderButtonClicked() {
        switch self.placeholderAction {
        case .getCounters:
            self.delegate?.refreshList()
        case .createCounter:
            self.delegate?.goToCreateCounter()
        default:
            break
        }
    }
    
    func decreaseBtnClicked(counter: Counter) {
        guard let id = counter.id else {
            self.delegate?.stopLoading()
            return
        }
        self.service.decreaseCounter(counterId: "\(id)") { [weak self] response in
            guard let selfObj = self else { return }
            switch response {
            case .success(let counters):
                selfObj.counters = counters
                selfObj.delegate?.decreaseCounterSuccess()
            case .failure(let error):
                selfObj.delegate?.stopLoading()
                selfObj.delegate?.showAlert(withTitle: error.title, andMessage: error.message)
            }
        }
    }
    
    func increaseBtnClicked(counter: Counter) {
        guard let id = counter.id else {
            self.delegate?.stopLoading()
            return
        }
        self.service.increaseCounter(counterId: "\(id)") { [weak self] response in
            guard let selfObj = self else { return }
            switch response {
            case .success(let counters):
                selfObj.counters = counters
                selfObj.delegate?.increaseCounterSuccess()
            case .failure(let error):
                selfObj.delegate?.stopLoading()
                selfObj.delegate?.showAlert(withTitle: error.title, andMessage: error.message)
            }
        }
    }
    
    func bottomViewLeftButtonClicked() {
        //TODO: delete
    }
    
    func bottomViewRightButtonClicked() {
        if isEditionMode {
            //TODO: share
        } else {
            self.delegate?.goToCreateCounter()
        }
    }
    
    func navigationLeftButtonClicked() {
        isEditionMode = !isEditionMode
    }
    
    func navigationRightButtonClicked() {
        //TODO: select all
    }
    
}

private extension CounterListViewPresenter {
    func checkEmptyCountersList() {
        if self.counters.count == 0 {
            self.isEditionAvailable = false
            self.showNoCountersPlaceholder()
        } else {
            self.isEditionAvailable = true
        }
    }
    
    func showNoCountersPlaceholder() {
        self.placeholderAction = .createCounter
        self.delegate?.showPlaceholder(
            withTitle: NSLocalizedString("NO_COUNTERS", comment: ""),
            subtitle: NSLocalizedString("NO_COUNTERS_DESCRIPTION", comment: ""),
            btnTitle: NSLocalizedString("BTN_CREATE_COUNTER", comment: ""))
    }
    
    func showRetryPlaceholder(error: BaseResponse) {
        self.placeholderAction = .getCounters
        self.delegate?.showPlaceholder(
            withTitle: error.title,
            subtitle: error.message,
            btnTitle:  NSLocalizedString("RETRY", comment: ""))
    }
    
    func updateCounts() {
        if isEditionMode {
            setViewEditionMode()
        } else {
            dismissViewEditionMode()
        }
    }
    
    func setViewEditionMode(){
        guard let image = UIImage(systemName: "square.and.arrow.up") else {return}
        self.delegate?.updateBottomViewWith(
            leftButtonEnabled: true,
            rightButtonIcon: image,
            totalItems: "",
            totalCounts: "")
        self.delegate?.updateNavigationBar()
    }
    
    func dismissViewEditionMode() {
        guard let image = UIImage(systemName: "plus") else {return}
        let totalItems = getNumberOfCountersDescription()
        let totalCounts = getCountedDescription()
        self.delegate?.updateBottomViewWith(
            leftButtonEnabled: false,
            rightButtonIcon: image,
            totalItems: totalItems,
            totalCounts: totalCounts)
        self.delegate?.updateNavigationBar()
    }
    
    func getNumberOfCountersDescription() -> String {
        guard self.counters.count != 0 else {return ""}
        return "\(self.counters.count) items • "
    }
    
    func getCountedDescription() -> String {
        guard self.counters.count != 0 else {return ""}
        var totalCount = 0
        for counter in counters {
            if let count = counter.count {
                totalCount += count
            }
        }
        return totalCount != 0 ? "Counted \(totalCount) times" : ""
    }
}
