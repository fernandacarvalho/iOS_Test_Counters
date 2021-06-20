//
//  CountersListView.swift
//  Counters
//
//  Created by Fernanda FC. Carvalho on 19/06/21.
//

import Foundation
import UIKit

protocol CountersListViewDelegate: AnyObject {
    func didClickAddButton()
    func refreshList()
}

private enum CellReuseIdentifier: String {
    case counter = "counterCell"
}

class CountersListView: BaseView {
    
    // MARK: - View Model
    
    struct ViewModel {
        let counters: [Counter]
    }
    
    // MARK: - Properties
    
    @IBOutlet weak var searchBar: CountersSearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var placeholderContainerView: UIView!
    
    private weak var delegate: CountersListViewDelegate?
    private var viewModel: ViewModel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.loadNib()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func loadNib() {
        if let nib = Bundle.main.loadNibNamed("CountersListView", owner: self),
            let nibView = nib.first as? UIView {
            nibView.frame = bounds
            nibView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            addSubview(nibView)
        }
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
    
    //MARK: - Placeholder
    override func placeholderActionHandler() {
        super.placeholderActionHandler()
    }
    
    // MARK: - Configuration
    
    func configure(with viewModel: ViewModel, andDelegate delegate: CountersListViewDelegate) {
        self.configurePlaceholderView(parentView: self.placeholderContainerView)
        self.delegate = delegate
        self.viewModel = viewModel
        self.setupTableView()
        //self.setPlaceholderView(withTitle: "No counters yet", subtitle: "Some description text", btnTitle: "Create a counter")
    }
    
    func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.refreshValueChanged), for: .valueChanged)
        self.tableView.refreshControl = refreshControl
        self.tableView.register(UINib(nibName: "CounterTableViewCell", bundle: nil), forCellReuseIdentifier: CellReuseIdentifier.counter.rawValue)
    }
    
    //MARK: - Actions
    
    @objc func refreshValueChanged() {
        DispatchQueue.main.async {
            self.tableView.refreshControl?.endRefreshing()
        }
    }
}

extension CountersListView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel?.counters.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let counter = self.viewModel?.counters[indexPath.row] else {return UITableViewCell()}
        let cell = self.tableView.dequeueReusableCell(withIdentifier: CellReuseIdentifier.counter.rawValue) as! CounterTableViewCell
        cell.configureCell(counter: counter, delegate: self)
        return cell
    }
}

extension CountersListView: CounterTableViewCellDelegate {
    func didClickDecreaseBtn(counter: Counter) {
        
    }
    
    func didClickIncreaseBtn(counter: Counter) {
        
    } 
}
