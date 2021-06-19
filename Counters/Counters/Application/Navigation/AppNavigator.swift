//
//  AppNavigator.swift
//  Counters
//
//  Created by Fernanda FC. Carvalho on 19/06/21.
//

import Foundation
import UIKit

private let data = AppNavigator()

class AppNavigator: NSObject {
        
    class var sharedInstance : AppNavigator {
        return data
    }
    
    override init() {
        super.init()
    }
    
    //MARK: -REDIRECT
    //Root
    
    /**
     AppNavigator
     
     *Method:*
     
     - func goToHome(withTransition: Bool)
     
     Change application's root
     
     */
    func goToHome(withTransition: Bool) {
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.changeRootToHome(withTransition: withTransition)
        }
    }
}
