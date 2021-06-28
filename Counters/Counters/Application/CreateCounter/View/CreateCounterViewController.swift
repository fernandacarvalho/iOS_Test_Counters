//
//  CreateCounterViewController.swift
//  Counters
//
//  Created by Fernanda FC. Carvalho on 28/06/21.
//

import UIKit

class CreateCounterViewController: BaseViewController {
    
    @IBOutlet weak var nameInputField: UITextField!
    @IBOutlet weak var linkButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupLink()
    }
    
    private func setupLink() {
        let attributedString = NSAttributedString(string: NSLocalizedString("SEE_EXAMPLES", comment: ""), attributes:[
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12.0),
            NSAttributedString.Key.foregroundColor : UIColor.gray,
            NSAttributedString.Key.underlineStyle:1.0
        ])
        
        self.linkButton.setAttributedTitle(attributedString, for: .normal)
    }
}
