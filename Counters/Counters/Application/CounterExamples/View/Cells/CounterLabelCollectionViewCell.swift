//
//  CounterLabelCollectionViewCell.swift
//  Counters
//
//  Created by Fernanda FC. Carvalho on 29/06/21.
//

import UIKit

class CounterLabelCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var counterLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        counterLabel.text = ""
    }
    
    func setLabel(withText text: String) {
        self.counterLabel.text = text
    }

}
