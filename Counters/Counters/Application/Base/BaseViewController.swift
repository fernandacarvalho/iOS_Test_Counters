//
//  BaseViewController.swift
//  Counters
//
//  Created by Fernanda FC. Carvalho on 19/06/21.
//

import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: NavigationBar
    func setNavigationLeftButton(withTitle title: String, andImage img: UIImage? = nil) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        let leftButton = UIButton()
        leftButton.setTitle(title, for: .normal)
        leftButton.setTitleColor(.accentColor, for: .normal)
        leftButton.setTitleColor(.disabledText, for: .disabled)
        leftButton.tintColor = .accentColor
        leftButton.addTarget(self, action: #selector(handleNavigationLeftBtnClick), for: .touchUpInside)
        if let image = img {
            leftButton.setImage(image, for: .normal)
        }
        let leftBarButton = UIBarButtonItem(customView: leftButton)
        self.navigationItem.leftBarButtonItem = leftBarButton
    }
    
    func setNavigationRightButton(withTitle title: String, andImage img: UIImage? = nil) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        let rightButton = UIButton()
        rightButton.setTitle(title, for: .normal)
        rightButton.setTitleColor(.accentColor, for: .normal)
        rightButton.setTitleColor(.disabledText, for: .disabled)
        rightButton.tintColor = .accentColor
        rightButton.addTarget(self, action: #selector(handleNavigationRightBtnClick), for: .touchUpInside)
        if let image = img {
            rightButton.setImage(image, for: .normal)
        }
        let rightBarButton = UIBarButtonItem(customView: rightButton)
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    func updateNavigationLeftBarButtonState(enabled: Bool) {
        self.navigationItem.leftBarButtonItem?.isEnabled = enabled
    }
    
    func updateNavigationRightBarButtonState(enabled: Bool) {
        self.navigationItem.rightBarButtonItem?.isEnabled = enabled
    }
    
    @objc func handleNavigationLeftBtnClick() {}
    
    @objc func handleNavigationRightBtnClick() {}
    
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
}


