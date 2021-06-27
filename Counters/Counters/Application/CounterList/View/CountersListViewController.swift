//
//  CountersListViewController.swift
//  Counters
//
//  Created by Fernanda FC. Carvalho on 19/06/21.
//

import UIKit

private enum CellReuseIdentifier: String {
    case counter = "counterCell"
}

class CountersListViewController: BaseViewController {
    
    //MARK: IBOUTLETS
    @IBOutlet weak var searchBar: CountersSearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var placeholderContainerView: UIView!
    
    private var presenter: CounterListViewPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter = CounterListViewPresenter(delegate: self)
        self.setupTableView()
        self.setupNavigation()
        self.configurePlaceholderView(parentView: self.placeholderContainerView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getList()
    }
    
    override func configurePlaceholderView(parentView: UIView) {
        super.configurePlaceholderView(parentView: parentView)
        NSLayoutConstraint.activate([
            placeholderView.leadingAnchor.constraint(equalTo: placeholderContainerView.leadingAnchor),
            placeholderView.trailingAnchor.constraint(equalTo: placeholderContainerView.trailingAnchor),
            placeholderView.topAnchor.constraint(equalTo: placeholderContainerView.topAnchor),
            placeholderView.bottomAnchor.constraint(equalTo: placeholderContainerView.bottomAnchor)
        ])
    }
    
    override func placeholderActionHandler() {
        super.placeholderActionHandler()
        self.presenter.placeholderButtonClicked()
    }
    
    private func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.refreshValueChanged), for: .valueChanged)
        self.tableView.refreshControl = refreshControl
        self.tableView.register(UINib(nibName: CounterTableViewCell.self.description(), bundle: nil), forCellReuseIdentifier: CellReuseIdentifier.counter.rawValue)
    }
    
    private func setupNavigation() {
        self.setNavigationLeftButton(withTitle: NSLocalizedString("BTN_EDIT", comment: ""))
    }
    
    override func handleNavigationLeftBtnClick() {
        print("nav left btn clicked")
    }
    
    override func handleNavigationRightBtnClick() {
        print("nav right btn clicked")
    }
    
    @objc func refreshValueChanged() {
        self.getList()
        DispatchQueue.main.async {
            self.tableView.refreshControl?.endRefreshing()
        }
    }
    
    private func getList() {
        self.showActivityIndicator()
        self.presenter.getListFromServer()
    }
}

//MARK: TABLEVIEW DELEGATE AND DATA SOURCE
extension CountersListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.presenter.counters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: CellReuseIdentifier.counter.rawValue) as? CounterTableViewCell else { return UITableViewCell()
            
        }
        cell.configureCell(counter: self.presenter.counters[indexPath.row], delegate: self)
        return cell
    }
}

extension CountersListViewController: CounterTableViewCellDelegate {
    func didClickDecreaseBtn(counter: Counter) {
        self.showActivityIndicator()
        self.presenter.decreaseBtnClicked(counter: counter)
    }
    
    func didClickIncreaseBtn(counter: Counter) {
        self.showActivityIndicator()
        self.presenter.increaseBtnClicked(counter: counter)
    }
}

extension CountersListViewController: CounterListViewPresenterDelegate {
    
    func showAlert(withTitle title: String, andMessage message: String) {
        self.showSimpleAlert(withTitle: title, andMessage: message)
    }
    
    func decreaseCounterSuccess() {
        self.removeActivityIndicator()
        self.tableView.reloadData()
    }
    
    func decreaseCounterError() {
        self.removeActivityIndicator()
    }
    
    func increaseCounterSuccess() {
        self.removeActivityIndicator()
        self.tableView.reloadData()
    }
    
    func increaseCounterError() {
        self.removeActivityIndicator()
    }
    
    func showPlaceholder(withTitle title: String, subtitle: String, btnTitle: String) {
        self.placeholderContainerView.isHidden = false
        self.setPlaceholderView(withTitle: title, subtitle: subtitle, btnTitle: btnTitle)
    }
    
    func hidePlaceholder() {
        self.placeholderContainerView.isHidden = true
    }
    
    func getCountersSuccess() {
        self.removeActivityIndicator()
        self.tableView.reloadData()
    }
    
    func getCountersError() {
        self.removeActivityIndicator()
    }
    
    func refreshList() {
        self.getList()
    }
    
    func createCounter() {
        //TODO: OPEN VC
    }
}
