//
//  CountersListViewController.swift
//  Counters
//
//  Created by Fernanda FC. Carvalho on 19/06/21.
//

import UIKit

class CountersListViewController: BaseViewController {

    private lazy var innerView = CountersListView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.showPlaceholderView(with: "No counters yet", subtitle: "Some description text.", btnTitle: "Create a counter")
    }
    
    override func loadView() {
        view = innerView
    }

    override func placeholderActionHandler() {
        super.placeholderActionHandler()
    }
}
