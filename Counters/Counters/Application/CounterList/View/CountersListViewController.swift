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
    @IBOutlet weak var placeholderView: GenericPlaceholderView!
    @IBOutlet weak var numberOfCountersLabel: UILabel!
    @IBOutlet weak var totalCountsLabel: UILabel!
    @IBOutlet weak var bottomLeftButton: UIButton!
    @IBOutlet weak var bottomRightButton: UIButton!
    
    private var presenter: CounterListViewPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter = CounterListViewPresenter(delegate: self)
        self.setupTableView()
        self.setupNavigation()
        self.configurePlaceholderView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getList()
    }
    
    //MARK: -Placeholder
    
    func configurePlaceholderView() {
        self.placeholderView.addTarget(self, action: #selector(self.placeholderActionHandler), for: .primaryActionTriggered)
    }
    
    private func showPlaceholderView() {
        self.placeholderView.isHidden = false
    }
    
    private func hidePlaceholderView() {
        self.placeholderView.isHidden = true
    }
    
    @objc func placeholderActionHandler() {
        self.hidePlaceholderView()
        self.presenter.placeholderButtonClicked()
    }
    
    //MARK: -Setups
    
    private func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.refreshValueChanged), for: .valueChanged)
        self.tableView.refreshControl = refreshControl
        self.tableView.register(UINib(nibName: "CounterTableViewCell", bundle: nil), forCellReuseIdentifier: CellReuseIdentifier.counter.rawValue)
    }
    
    @objc func refreshValueChanged() {
        self.getList()
        DispatchQueue.main.async {
            self.tableView.refreshControl?.endRefreshing()
        }
    }
    
    private func setupNavigation() {
        if self.presenter.isEditionMode {
            self.setNavigationLeftButton(withTitle: NSLocalizedString("BTN_DONE", comment: ""))
            self.setNavigationRightButton(withTitle: NSLocalizedString("BTN_SELECT_ALL", comment: ""))
        } else {
            self.setNavigationLeftButton(withTitle: NSLocalizedString("BTN_EDIT", comment: ""))
            self.navigationItem.rightBarButtonItem = nil
        }
    }
    
    private func updateNavigationState() {
        if self.presenter.isEditionAvailable {
            self.updateNavigationLeftBarButtonState(enabled: true)
            self.updateNavigationRightBarButtonState(enabled: self.presenter.isEditionMode ? true : false)
        } else {
            self.updateNavigationLeftBarButtonState(enabled: false)
            self.updateNavigationRightBarButtonState(enabled: false)
        }
    }
    
    private func getList() {
        self.showActivityIndicator()
        self.presenter.getListFromServer()
    }
    
    //MARK: -Actions
    
    @IBAction func bottomLeftBtnClicked(_ sender: Any) {
        self.presenter.bottomViewLeftButtonClicked()
    }
    
    @IBAction func bottomRightBtnClicked(_ sender: Any) {
        self.presenter.bottomViewRightButtonClicked()
    }
    
    override func handleNavigationLeftBtnClick() {
        self.presenter.navigationLeftButtonClicked()
    }
    
    override func handleNavigationRightBtnClick() {
        self.presenter.navigationRightButtonClicked()
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
    
    func showPlaceholder(withTitle title: String, subtitle: String, btnTitle: String) {
        self.placeholderView.setInfo(with: title, subtitle: subtitle, btnTitle: btnTitle)
        self.showPlaceholderView()
    }
    
    func stopLoading() {
        self.removeActivityIndicator()
    }
    
    func refreshList() {
        self.getList()
    }
    
    func decreaseCounterSuccess() {
        self.removeActivityIndicator()
        self.tableView.reloadData()
    }
    
    func increaseCounterSuccess() {
        self.removeActivityIndicator()
        self.tableView.reloadData()
    }
    
    func getCountersSuccess() {
        self.removeActivityIndicator()
        self.tableView.reloadData()
        self.updateNavigationState()
    }
    
    func goToCreateCounter() {
        let controller = CreateCounterViewController()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func updateBottomViewWith(leftButtonEnabled: Bool, rightButtonIcon: UIImage, totalItems: String, totalCounts: String) {
        self.bottomLeftButton.isHidden = !leftButtonEnabled
        self.bottomRightButton.setImage(rightButtonIcon, for: .normal)
        self.numberOfCountersLabel.text = totalItems
        self.totalCountsLabel.text = totalCounts
    }
    
    func updateNavigationBar() {
        self.setupNavigation()
        self.updateNavigationState()
    }
}
