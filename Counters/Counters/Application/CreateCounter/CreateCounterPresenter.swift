//
//  CreateCounterPresenter.swift
//  Counters
//
//  Created by Fernanda FC. Carvalho on 28/06/21.
//

import Foundation

protocol CreateCounterPresenterDelegate: AnyObject {
    func createCounterSuccess()
    func showErrorAlert(withTitle title: String, andMessage message: String, btnTitle: String)
}

final class CreateCounterPresenter {
    
    private weak var delegate: CreateCounterPresenterDelegate?
    private var service: CreateCounterService
    
    init(delegate: CreateCounterPresenterDelegate, service: CreateCounterService = CreateCounterService()) {
        self.delegate = delegate
        self.service = service
    }
    
    func saveCounter(withName name: String) {
        service.createCounter(counterName: name) { [weak self] response in
            guard let selfObj = self else { return }
            switch response {
            case .success( _):
                selfObj.delegate?.createCounterSuccess()
            case .failure(let error):
                selfObj.delegate?.showErrorAlert(
                    withTitle: error.title,
                    andMessage: error.message,
                    btnTitle: NSLocalizedString("BTN_DISMISS", comment: ""))
            }
        }
    }
}
