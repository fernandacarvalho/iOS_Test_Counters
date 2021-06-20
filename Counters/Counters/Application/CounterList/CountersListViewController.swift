//
//  CountersListViewController.swift
//  Counters
//
//  Created by Fernanda FC. Carvalho on 19/06/21.
//

import UIKit


class CountersListViewController: BaseViewController {

    private lazy var innerView = CountersListView()
    private let presenter = CounterListViewPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter.delegate = self
    }
    
    override func loadView() {
        self.innerView.configure(with: presenter.getViewModel(), andDelegate: self)
        self.view = innerView
        self.setNavigationLeftButton(withTitle: NSLocalizedString("BTN_EDIT", comment: ""))
        presenter.delegate = self
        presenter.getListFromServer()
    }
    
    override func handleNavigationLeftBtnClick() {
        print("nav left btn clicked")
    }
    
    override func handleNavigationRightBtnClick() {
        print("nav right btn clicked")
    }
}

extension CountersListViewController: CountersListViewDelegate {
    func didClickAddButton() {
        presenter.test()
    }
    
    func refreshList() {
        presenter.getListFromServer()
    }
    
    func increaseCounter(counter: Counter) {
        
    }
    
    func decreaseCounter(counter: Counter) {
        
    }
}

extension CountersListViewController: CounterListViewPresenterDelegate {
    func didUpdateViewModel() {
        DispatchQueue.main.async {
            self.innerView.viewModel = self.presenter.getViewModel()
        }
    }
    
    func getCountersError(baseResponse: BaseResponse) {
        baseResponse.title = NSLocalizedString("COULDNT_LOAD_COUNTERS", comment: "")
        DispatchQueue.main.async {
            self.innerView.setErrorView(error: baseResponse, errorType: .countersNotGet)
        }
    }
}
