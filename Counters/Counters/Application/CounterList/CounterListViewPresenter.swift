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
    func reloadTableView()
    func selectAllTableViewRows()
    func refreshList()
    func clearSearch(isEnabled: Bool)
    func goToCreateCounter()
    func showPlaceholder(withTitle title: String, subtitle: String, btnTitle: String)
    func showAlert(withTitle title: String, andMessage message: String)
    func stopLoading()
    func getCountersSuccess()
    func counterUpdateCountingSuccess()
    func updateBottomViewWith(leftButtonEnabled: Bool, rightButtonIcon: UIImage, totalItems: String, totalCounts: String)
    func updateNavigationBar()
    func updateSearchBarState(isEnabled: Bool)
}

final class CounterListViewPresenter {
    
    private(set) var isEditionMode: Bool = false {
        didSet {
            updateCounts()
        }
    }
    private(set) var isEditionAvailable: Bool = false {
        didSet {
            delegate?.updateNavigationBar()
            delegate?.updateSearchBarState(isEnabled: isEditionAvailable)
        }
    }
    
    private var allCounters: [Counter] = [Counter]() {
        didSet {
            counters = allCounters
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
                selfObj.allCounters = counters
                selfObj.delegate?.getCountersSuccess()
                selfObj.checkEmptyCountersList()
                selfObj.updateCounts()
            case .failure(let error):
                selfObj.delegate?.stopLoading()
                selfObj.showRetryPlaceholder(error: error)
                selfObj.isEditionAvailable = false
                selfObj.updateCounts()
            }
        }
    }
    
    func placeholderButtonClicked() {
        switch placeholderAction {
        case .getCounters:
            delegate?.refreshList()
        case .createCounter:
            delegate?.goToCreateCounter()
        default:
            break
        }
    }
    
    func decreaseBtnClicked(counter: Counter) {
        guard let id = counter.id else {
            delegate?.stopLoading()
            return
        }
        self.service.decreaseCounter(counterId: "\(id)") { [weak self] response in
            guard let selfObj = self else { return }
            switch response {
            case .success(let counters):
                selfObj.allCounters = counters
                selfObj.delegate?.counterUpdateCountingSuccess()
                selfObj.updateCounts()
            case .failure(let error):
                selfObj.delegate?.stopLoading()
                selfObj.delegate?.showAlert(withTitle: error.title, andMessage: error.message)
            }
        }
    }
    
    func increaseBtnClicked(counter: Counter) {
        guard let id = counter.id else {
            delegate?.stopLoading()
            return
        }
        self.service.increaseCounter(counterId: "\(id)") { [weak self] response in
            guard let selfObj = self else { return }
            switch response {
            case .success(let counters):
                selfObj.allCounters = counters
                selfObj.delegate?.counterUpdateCountingSuccess()
                selfObj.updateCounts()
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
            delegate?.goToCreateCounter()
        }
    }
    
    func navigationLeftButtonClicked() {
        isEditionMode = !isEditionMode
        delegate?.clearSearch(isEnabled: !isEditionMode)
        delegate?.reloadTableView()
    }
    
    func navigationRightButtonClicked() {
        delegate?.selectAllTableViewRows()
    }
    
    func searchBarTextDidChange(text: String) {
        if text.isEmpty {
            counters = allCounters
            //todo remover placeholder
        } else {
            counters = [Counter]()
            var result = [Counter]()
            for counter in allCounters {
                if(counter.title?.lowercased().range(of: text.lowercased()) != nil) {
                    result.append(counter)
                }
            }
            counters = result.sorted(by: { (item1, item2) -> Bool in
                if let name1 = item1.title, let name2 = item2.title {
                    return name1 < name2
                }
                return false
            })
            if counters.count > 0 {
                //todo show placeholder
            } else {
                //todo remover placeholder
            }
        }
        
        delegate?.reloadTableView()
    }
}

private extension CounterListViewPresenter {
    func checkEmptyCountersList() {
        if counters.count == 0 {
            isEditionAvailable = false
            showNoCountersPlaceholder()
        } else {
            isEditionAvailable = true
        }
    }
    
    func showNoCountersPlaceholder() {
        placeholderAction = .createCounter
        delegate?.showPlaceholder(
            withTitle: NSLocalizedString("NO_COUNTERS", comment: ""),
            subtitle: NSLocalizedString("NO_COUNTERS_DESCRIPTION", comment: ""),
            btnTitle: NSLocalizedString("BTN_CREATE_COUNTER", comment: ""))
    }
    
    func showRetryPlaceholder(error: BaseResponse) {
        placeholderAction = .getCounters
        delegate?.showPlaceholder(
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
        delegate?.updateBottomViewWith(
            leftButtonEnabled: true,
            rightButtonIcon: image,
            totalItems: "",
            totalCounts: "")
        delegate?.updateNavigationBar()
    }
    
    func dismissViewEditionMode() {
        guard let image = UIImage(systemName: "plus") else {return}
        let totalItems = getNumberOfCountersDescription()
        let totalCounts = getCountedDescription()
        delegate?.updateBottomViewWith(
            leftButtonEnabled: false,
            rightButtonIcon: image,
            totalItems: totalItems,
            totalCounts: totalCounts)
        delegate?.updateNavigationBar()
    }
    
    func getNumberOfCountersDescription() -> String {
        guard counters.count != 0 else {return ""}
        return "\(counters.count) items • "
    }
    
    func getCountedDescription() -> String {
        guard counters.count != 0 else {return ""}
        var totalCount = 0
        for counter in counters {
            if let count = counter.count {
                totalCount += count
            }
        }
        return "Counted \(totalCount) times"
    }
}
