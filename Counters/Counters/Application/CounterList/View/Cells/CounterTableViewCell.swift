//
//  CounterTableViewCell.swift
//  Counters
//
//  Created by Fernanda FC. Carvalho on 19/06/21.
//

import UIKit

protocol CounterTableViewCellDelegate: AnyObject {
    func didClickDecreaseBtn(counter: Counter)
    func didClickIncreaseBtn(counter: Counter)
}

class CounterTableViewCell: UITableViewCell {
    
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    private var counter: Counter?
    private weak var delegate: CounterTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(counter: Counter, delegate: CounterTableViewCellDelegate) {
        self.counter = counter
        self.delegate = delegate
        self.countLabel.text = counter.count != nil ? "\(counter.count!)" : "0"
        self.nameLabel.text = counter.title ?? ""
    }
    
    @IBAction func decreaseCounterClicked(_ sender: Any) {
        if let counter = self.counter,
           let count = counter.count,
           count > 0 {
            self.delegate?.didClickDecreaseBtn(counter: counter)
        }
    }
    
    @IBAction func increaseCounterClicked(_ sender: Any) {
        if let counter = self.counter {
            self.delegate?.didClickIncreaseBtn(counter: counter)
        }
    }
    
}
