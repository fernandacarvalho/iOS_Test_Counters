//
//  EmptyListTableViewCell.swift
//  Counters
//
//  Created by Fernanda FC. Carvalho on 30/06/21.
//

import UIKit

class EmptyListTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
