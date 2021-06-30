//
//  CountersSearchBar.swift
//  Counters
//
//  Created by Fernanda FC. Carvalho on 19/06/21.
//

import UIKit

class CountersSearchBar: UISearchBar {
    
    override open var isUserInteractionEnabled: Bool {
        didSet {
            self.layoutSubviews()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.backgroundImage = UIImage()
        if let textField = self.value(forKey: "searchField") as? UITextField {
            let foregroundColor: UIColor = isUserInteractionEnabled ? .secondaryText : .disabledText
            textField.attributedPlaceholder =
                NSAttributedString(
                    string: textField.placeholder ?? "Search",
                    attributes: [
                        NSAttributedString.Key.foregroundColor: foregroundColor
                    ]
                )
            
            if let iconView = textField.leftView as? UIImageView {
                iconView.tintColor = isUserInteractionEnabled ? .secondaryText : .disabledText
            }
            textField.clearButtonMode = .never
        }
    }
}
