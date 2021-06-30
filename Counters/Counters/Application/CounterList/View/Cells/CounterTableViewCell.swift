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
    @IBOutlet weak var decreaseBtn: UIButton!
    @IBOutlet weak var increaseBtn: UIButton!
    
    private var counter: Counter?
    private weak var delegate: CounterTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        decreaseBtn.setTitleColor(.disabledText, for: .disabled)
        decreaseBtn.setTitleColor(.primaryText, for: .normal)
        increaseBtn.setTitleColor(.disabledText, for: .disabled)
        increaseBtn.setTitleColor(.primaryText, for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(counter: Counter, delegate: CounterTableViewCellDelegate) {
        self.counter = counter
        self.delegate = delegate
        countLabel.text = counter.count != nil ? "\(counter.count!)" : "0"
        nameLabel.text = counter.title ?? ""
        updateUI()
    }
    
    func updateUI() {
        if let count = counter?.count {
            countLabel.textColor = count == 0 ? .disabledText : .accentColor
            decreaseBtn.isEnabled = count != 0
        } else {
            countLabel.textColor = .disabledText
            decreaseBtn.isEnabled = false
        }
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
