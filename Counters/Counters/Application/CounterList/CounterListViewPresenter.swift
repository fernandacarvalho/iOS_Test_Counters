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
    func removePlaceholder()
    func showAlert(withTitle title: String, andMessage message: String)
    func stopLoading()
    func showLoading()
    func getCountersSuccess()
    func counterUpdateCountingSuccess()
    func updateBottomViewWith(leftButtonEnabled: Bool, rightButtonIcon: UIImage, totalItems: String, totalCounts: String)
    func updateNavigationBar()
    func updateSearchBarState(isEnabled: Bool)
    func presentActionSheet(actionSheet: UIAlertController)
    func shareItems(items: [Any])
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
    private var selectedCounters: [IndexPath]?
    private var deleteCount: Int = 0
    private var deleteErrors = [BaseResponse]()
    
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
                selfObj.resetPlaceholder()
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
            resetPlaceholder()
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
                let title = "\(error.title) '\(counter.title ?? "")'"
                selfObj.delegate?.showAlert(withTitle: title, andMessage: error.message)
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
                let title = "\(error.title) '\(counter.title ?? "")'"
                selfObj.delegate?.showAlert(withTitle: title, andMessage: error.message)
            }
        }
    }
    
    func bottomViewLeftButtonClicked() {
        if let rows = selectedCounters,
           rows.count > 0 {
            createDeletionActionSheet()
        } else {
            delegate?.showAlert(
                withTitle: NSLocalizedString("NO_COUNTER_SELECTED", comment: ""),
                andMessage: NSLocalizedString("SELECT_COUNTERS", comment: ""))
        }
    }
    
    func bottomViewRightButtonClicked() {
        if isEditionMode {
            shareSelectedCounters()
        } else {
            delegate?.goToCreateCounter()
        }
    }
    
    func navigationLeftButtonClicked() {
        isEditionMode = !isEditionMode
        delegate?.clearSearch(isEnabled: !isEditionMode)
        delegate?.reloadTableView()
        selectedCounters = nil
    }
    
    func navigationRightButtonClicked() {
        delegate?.selectAllTableViewRows()
    }
    
    func searchBarTextDidChange(text: String) {
        if text.isEmpty {
            counters = allCounters
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
        }
        delegate?.reloadTableView()
    }
    
    func setSelectedTableViewRows(rows: [IndexPath]?) {
        selectedCounters = rows
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
    
    func resetPlaceholder() {
        placeholderAction = .none
        delegate?.removePlaceholder()
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
    
    func createDeletionActionSheet() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.view.tintColor = .accentColor
        let cancelAction = UIAlertAction(title: NSLocalizedString("BTN_CANCEL", comment: ""), style: .cancel)
        
        let delete = UIAlertAction(title: NSLocalizedString("BTN_DELETE_SELECTED_COUNTERS", comment: ""), style: .default) { action in
            self.deleteSelectedCounters()
        }
        actionSheet.addAction(cancelAction)
        actionSheet.addAction(delete)
        delegate?.presentActionSheet(actionSheet: actionSheet)
    }
    
    func deleteSelectedCounters() {
        if let rows = selectedCounters,
           rows.count > 0 {
            delegate?.showLoading()
            for row in rows {
                deleteCounter(counter: allCounters[row.row])
            }
        }
    }
    
    func deleteCounter(counter: Counter) {
        guard let id = counter.id else {return}
        service.deleteCounter(counterId: id, completionHandler: handleCountersDeletion(response:))
    }
    
    func handleCountersDeletion(response: RequestResultType<[Counter]>) {
        deleteCount += 1
        
        switch response {
        case .success( _):
            debugPrint("counter deleted")
        case .failure(let error):
            debugPrint("didn't delete counter")
            deleteErrors.append(error)
        }
        
        if let totalCount = selectedCounters?.count, deleteCount == totalCount {
            delegate?.stopLoading()
            navigationLeftButtonClicked()
            delegate?.refreshList()
            if deleteErrors.count > 0 {
                var title = NSLocalizedString("COULDNT_DELETE_COUNTER", comment: "")
                let message = deleteErrors[0].message
                for error in deleteErrors {
                    let result = allCounters.filter({$0.id == error.extraInfo})
                    if let counter = result.first, let name = counter.title {
                        title += " '\(name)' "
                    }
                }
                delegate?.showAlert(withTitle: title, andMessage: message)
            }
            selectedCounters = nil
            deleteErrors = [BaseResponse]()
            deleteCount = 0
        }
    }
    
    func shareSelectedCounters() {
        var items = [String]()
        if let rows = selectedCounters,
           rows.count > 0 {
            for row in rows {
                let counter = allCounters[row.row]
                if let name = counter.title, let count = counter.count {
                    let description = "\(count) x \(name)"
                    items.append(description)
                }
            }
            delegate?.shareItems(items: items)
        } else {
            delegate?.showAlert(
                withTitle: NSLocalizedString("NO_COUNTER_SELECTED", comment: ""),
                andMessage: NSLocalizedString("SELECT_COUNTERS", comment: ""))
        }
    }
}
