//
//  BaseViewController.swift
//  Counters
//
//  Created by Fernanda FC. Carvalho on 19/06/21.
//

import UIKit

class BaseViewController: UIViewController {
    
    private var placeholderView = GenericPlaceholderView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configurePlaceholderView()
    }
    
    //MARK: Loading
    
    func showActivityIndicator() {
        ActivityIndicatorView.showActivityIndicatorView(onView: self.navigationController?.view ?? self.view)
    }
    
    func removeActivityIndicator() {
        ActivityIndicatorView.removeActivityIndicatorView()
    }
    
    //MARK: Alert
    
    func showSimpleAlert(withTitle title: String, andMessage message: String?, buttonTitle: String? = "Ok") {
        let alert = UIAlertController(title: title, message: message ?? "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonTitle , style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    func showCallbackAlert(title: String, message: String?, confirmButtonTitle: String? = "Ok", cancelButtonTitle: String? = nil, confirm: @escaping () -> (), cancel: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message ?? "", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: confirmButtonTitle, style: .default, handler: { (action) in
            confirm()
        }))
        
        if let cancelTitle = cancelButtonTitle {
            alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel, handler: { (action) in
                cancel?()
            }))
        }
        
        self.present(alert, animated: true)
    }
    
    //MARK: -Placeholder
    
    func configurePlaceholderView() {
        self.placeholderView.isHidden = true
        self.placeholderView.addTarget(self, action: #selector(self.placeholderActionHandler), for: .primaryActionTriggered)
        self.placeholderView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(self.placeholderView)
    }
    
    func hidePlaceholderView() {
        self.placeholderView.isHidden = true
    }
    
    func showPlaceholderView(with title: String, subtitle: String, btnTitle: String) {
        self.placeholderView.setInfo(with: title, subtitle: subtitle, btnTitle: btnTitle)
        self.placeholderView.isHidden = false
    }
    
    @objc func placeholderActionHandler() {
        self.hidePlaceholderView()
    }
}


