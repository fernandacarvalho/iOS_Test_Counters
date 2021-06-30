//
//  CounterExamplesViewController.swift
//  Counters
//
//  Created by Fernanda FC. Carvalho on 29/06/21.
//

import UIKit

private enum CellReuseIdentifiers: String {
    case exampleCell = "exampleCell"
}

protocol CounterExamplesDelegate: AnyObject {
    func didSelectExample(name: String)
}

class CounterExamplesViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    private var presenter = CounterExamplesPresenter()
    private weak var delegate: CounterExamplesDelegate?
    
    init(delegate: CounterExamplesDelegate) {
        super.init(nibName: nil, bundle: nil)
        self.delegate = delegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        tableView.register(UINib(nibName: "CounterExampleTableViewCell", bundle: nil), forCellReuseIdentifier: CellReuseIdentifiers.exampleCell.rawValue)
    }
}

//MARK: UITABLEVIEW DELEGATE AND DATASOURCE
extension CounterExamplesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.viewModel.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellReuseIdentifiers.exampleCell.rawValue, for: indexPath) as? CounterExampleTableViewCell else {
            return UITableViewCell()
        }
        cell.configureCellWith(example: presenter.viewModel[indexPath.section], delegate: self)
        return cell
    }
}

//MARK: TABLEVIEWCELL DELEGATE
extension CounterExamplesViewController: CounterExampleCellDelegate {
    func didSelectExampleItem(item: String) {
        delegate?.didSelectExample(name: item)
        navigationController?.popViewController(animated: true)
    }
}
