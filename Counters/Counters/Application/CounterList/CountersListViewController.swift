//
//  CountersListViewController.swift
//  Counters
//
//  Created by Fernanda FC. Carvalho on 19/06/21.
//

import UIKit

protocol CountersListViewControllerPresenter {
    var viewModel: CountersListView.ViewModel { get }
}

class CountersListViewController: BaseViewController {

    private lazy var innerView = CountersListView()
    private let presenter = CounterListViewPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        self.innerView.configure(with: presenter.viewModel, andDelegate: self)
        self.view = innerView
        self.setNavigationLeftButton(withTitle: NSLocalizedString("BTN_EDIT", comment: ""))
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
        
    }
    
    func refreshList() {
        
    }
}
 
