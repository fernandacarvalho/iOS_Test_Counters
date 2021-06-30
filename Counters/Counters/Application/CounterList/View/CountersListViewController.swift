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
        presenter = CounterListViewPresenter(delegate: self)
        setupTableView()
        setupNavigation()
        configurePlaceholderView()
        searchBar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getList()
    }
    
    //MARK: -Placeholder
    
    func configurePlaceholderView() {
        placeholderView.addTarget(self, action: #selector(self.placeholderActionHandler), for: .primaryActionTriggered)
    }
    
    private func showPlaceholderView() {
        placeholderView.isHidden = false
    }
    
    private func hidePlaceholderView() {
        placeholderView.isHidden = true
    }
    
    @objc func placeholderActionHandler() {
        hidePlaceholderView()
        presenter.placeholderButtonClicked()
    }
    
    //MARK: -Setups
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.refreshValueChanged), for: .valueChanged)
        tableView.refreshControl = refreshControl
        tableView.register(UINib(nibName: "CounterTableViewCell", bundle: nil), forCellReuseIdentifier: CellReuseIdentifier.counter.rawValue)
    }
    
    @objc func refreshValueChanged() {
        self.getList()
        DispatchQueue.main.async {
            self.tableView.refreshControl?.endRefreshing()
        }
    }
    
    private func setupNavigation() {
        if self.presenter.isEditionMode {
            setNavigationLeftButton(withTitle: NSLocalizedString("BTN_DONE", comment: ""))
            setNavigationRightButton(withTitle: NSLocalizedString("BTN_SELECT_ALL", comment: ""))
        } else {
            setNavigationLeftButton(withTitle: NSLocalizedString("BTN_EDIT", comment: ""))
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    private func updateNavigationState() {
        if self.presenter.isEditionAvailable {
            updateNavigationLeftBarButtonState(enabled: true)
            updateNavigationRightBarButtonState(enabled: self.presenter.isEditionMode ? true : false)
        } else {
            updateNavigationLeftBarButtonState(enabled: false)
            updateNavigationRightBarButtonState(enabled: false)
        }
    }
    
    private func getList() {
        showActivityIndicator()
        presenter.getListFromServer()
    }
    
    //MARK: -Actions
    
    @IBAction func bottomLeftBtnClicked(_ sender: Any) {
        presenter.bottomViewLeftButtonClicked()
    }
    
    @IBAction func bottomRightBtnClicked(_ sender: Any) {
        presenter.bottomViewRightButtonClicked()
    }
    
    override func handleNavigationLeftBtnClick() {
        presenter.navigationLeftButtonClicked()
    }
    
    override func handleNavigationRightBtnClick() {
        presenter.navigationRightButtonClicked()
    }
}

//MARK: TABLEVIEW DELEGATE AND DATA SOURCE
extension CountersListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.counters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellReuseIdentifier.counter.rawValue) as? CounterTableViewCell else { return UITableViewCell()
            
        }
        cell.configureCell(counter: presenter.counters[indexPath.row], delegate: self)
        return cell
    }
}

//MARK: TABLEVIEWCELL DELEGATE
extension CountersListViewController: CounterTableViewCellDelegate {
    func didClickDecreaseBtn(counter: Counter) {
        showActivityIndicator()
        presenter.decreaseBtnClicked(counter: counter)
    }
    
    func didClickIncreaseBtn(counter: Counter) {
        showActivityIndicator()
        presenter.increaseBtnClicked(counter: counter)
    }
}

//MARK: UISEARCHBAR DELEGATE
extension CountersListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter.searchBarTextDidChange(text: searchText)
    }
}

//MARK: PRESENTER DELEGATE
extension CountersListViewController: CounterListViewPresenterDelegate {
    
    func showAlert(withTitle title: String, andMessage message: String) {
        showSimpleAlert(withTitle: title, andMessage: message)
    }
    
    func showPlaceholder(withTitle title: String, subtitle: String, btnTitle: String) {
        placeholderView.setInfo(with: title, subtitle: subtitle, btnTitle: btnTitle)
        showPlaceholderView()
    }
    
    func stopLoading() {
        removeActivityIndicator()
    }
    
    func reloadTableView() {
        tableView.reloadData()
    }
    
    func refreshList() {
        getList()
    }
    
    func clearSearch(isEnabled: Bool) {
        searchBar.text = ""
        presenter.searchBarTextDidChange(text: "")
        searchBar.isUserInteractionEnabled = isEnabled
    }
    
    func counterUpdateCountingSuccess() {
        removeActivityIndicator()
        tableView.reloadData()
        updateNavigationState()
        if let text = searchBar.text {
            presenter.searchBarTextDidChange(text: text)
        }
    }
    
    func getCountersSuccess() {
        removeActivityIndicator()
        tableView.reloadData()
        updateNavigationState()
    }
    
    func goToCreateCounter() {
        let controller = CreateCounterViewController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func updateBottomViewWith(leftButtonEnabled: Bool, rightButtonIcon: UIImage, totalItems: String, totalCounts: String) {
        bottomLeftButton.isHidden = !leftButtonEnabled
        bottomRightButton.setImage(rightButtonIcon, for: .normal)
        numberOfCountersLabel.text = totalItems
        totalCountsLabel.text = totalCounts
    }
    
    func updateNavigationBar() {
        setupNavigation()
        updateNavigationState()
    }
}
