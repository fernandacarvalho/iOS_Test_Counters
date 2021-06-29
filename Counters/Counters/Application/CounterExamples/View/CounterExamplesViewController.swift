//
//  CounterExamplesViewController.swift
//  Counters
//
//  Created by Fernanda FC. Carvalho on 29/06/21.
//

import UIKit

class CounterExamplesViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigation()
        setupTableView()
    }
    
    //MARK: Navigation
    
    private func setupNavigation() {
        self.navigationItem.title = NSLocalizedString("BTN_CREATE_COUNTER", comment: "")
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension CounterExamplesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
