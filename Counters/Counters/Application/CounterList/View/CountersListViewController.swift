//
//  CountersListViewController.swift
//  Counters
//
//  Created by Fernanda FC. Carvalho on 19/06/21.
//

import UIKit

private enum CellReuseIdentifier: String {
    case counter = "counterCell"
    case empty = "emptyCell"
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
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        hidePlaceholderView()
        resetSearchBar()
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
        tableView.register(UINib(nibName: "EmptyListTableViewCell", bundle: nil), forCellReuseIdentifier: CellReuseIdentifier.empty.rawValue)
    }
    
    @objc func refreshValueChanged() {
        resetSearchBar()
        getList()
        DispatchQueue.main.async {
            self.presenter.setSelectedTableViewRows(rows: self.tableView.indexPathsForSelectedRows)
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
        updateNavigationLeftBarButtonState(enabled: presenter.isEditionAvailable)
        updateNavigationRightBarButtonState(enabled: presenter.isEditionAvailable && presenter.isEditionMode)
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
    
    func resetSearchBar() {
        searchBar.text = ""
        searchBar(searchBar, textDidChange: searchBar.text!)
        self.view.endEditing(true)
    }
}

//MARK: TABLEVIEW DELEGATE AND DATA SOURCE
extension CountersListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.counters.count > 0 ? presenter.counters.count : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if presenter.counters.count > 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CellReuseIdentifier.counter.rawValue) as? CounterTableViewCell else { return UITableViewCell()
            }
            cell.configureCell(counter: presenter.counters[indexPath.row], delegate: self, updateAvailable: !presenter.isEditionMode)
            return cell
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellReuseIdentifier.empty.rawValue) as? EmptyListTableViewCell else {
            return UITableViewCell()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.setSelectedTableViewRows(rows: tableView.indexPathsForSelectedRows)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        presenter.setSelectedTableViewRows(rows: tableView.indexPathsForSelectedRows)
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
        searchBar.showsCancelButton = !searchText.isEmpty
        presenter.searchBarTextDidChange(text: searchText)
        if searchText.isEmpty {
            self.view.endEditing(true)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        resetSearchBar()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
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
    
    func removePlaceholder() {
        hidePlaceholderView()
    }
    
    func stopLoading() {
        removeActivityIndicator()
    }
    
    func showLoading() {
        showActivityIndicator()
    }
    
    func reloadTableView() {
        if presenter.isEditionMode {
            tableView.allowsMultipleSelection = true
            tableView.allowsMultipleSelectionDuringEditing = true
        } else {
            tableView.allowsSelection = false
            tableView.allowsSelectionDuringEditing = false
        }        
        tableView.reloadData()
    }
    
    func selectAllTableViewRows() {
        for section in 0..<tableView.numberOfSections {
            for row in 0..<tableView.numberOfRows(inSection: section) {
                let indexPath = IndexPath(row: row, section: section)
                _ = tableView.delegate?.tableView?(tableView, willSelectRowAt: indexPath)
                tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
                tableView.delegate?.tableView?(tableView, didSelectRowAt: indexPath)
            }
        }
    }
    
    func refreshList() {
        getList()
    }
    
    func clearSearch(isEnabled: Bool) {
        resetSearchBar()
        updateSearchBarState(isEnabled: isEnabled)
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
    
    func updateSearchBarState(isEnabled: Bool) {
        searchBar.isUserInteractionEnabled = isEnabled
    }
    
    func presentActionSheet(actionSheet: UIAlertController) {
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func shareItems(items: [Any]) {
        let activityController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        self.present(activityController, animated: true, completion: nil)
    }
}
