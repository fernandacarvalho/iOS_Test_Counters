//
//  CountersCardView.swift
//  Counters
//
//  Created by Fernanda FC. Carvalho on 19/06/21.
//

import UIKit

class OiGTCardView: UIView {

        override func layoutSubviews() {
            super.layoutSubviews()
    
            self.backgroundColor = .cardBackground
            self.layer.cornerRadius = 8
        }
}

class OiGTShadowCard: OiGTCardView {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOpacity = 0.1
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 5
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.masksToBounds = false
    }
}



