//
//  ActivityIndicatorView.swift
//  Counters
//
//  Created by Fernanda FC. Carvalho on 19/06/21.
//

import Foundation
import UIKit

class ActivityIndicatorView {
    
    static var vSpinner : UIView?
    
    class func showActivityIndicatorView(onView : UIView) {
        vSpinner?.removeFromSuperview()
        vSpinner = nil
        let spinnerView = UIView.init(frame: UIScreen.main.bounds)
        spinnerView.backgroundColor = UIColor.clear
        let ai = UIActivityIndicatorView.init(style: .gray)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
            vSpinner = spinnerView
        }
    }
    
    class func removeActivityIndicatorView() {
       DispatchQueue.main.async {
            vSpinner?.removeFromSuperview()
            vSpinner = nil
        }
    }
}
