//
//  BaseView.swift
//  Counters
//
//  Created by Fernanda FC. Carvalho on 19/06/21.
//

import UIKit

class BaseView: UIView {

    lazy var placeholderView = GenericPlaceholderView()
    
    //MARK: -Placeholder
    
    func configurePlaceholderView(parentView: UIView) {
        self.placeholderView.addTarget(self, action: #selector(self.placeholderActionHandler), for: .primaryActionTriggered)
        self.placeholderView.translatesAutoresizingMaskIntoConstraints = false
        self.hidePlaceholderView()
        parentView.addSubview(self.placeholderView)
    }
    
    func setPlaceholderView(withTitle title: String, subtitle: String, btnTitle: String) {
        self.placeholderView.setInfo(with: title, subtitle: subtitle, btnTitle: btnTitle)
        self.showPlaceholderView()
    }
 
    private func showPlaceholderView() {
        self.placeholderView.isHidden = false
    }
    
    private func hidePlaceholderView() {
        self.placeholderView.isHidden = true
    }
    
    @objc func placeholderActionHandler() {
        self.hidePlaceholderView()
    }
}
