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
    private var presenter: CreateCounterPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = CreateCounterPresenter(delegate: self)
        setupNavigation()
        setupTextField()
        setupLink()
    }
    
    private func setupTextField() {
        nameInputField.delegate = self
        nameInputField.addTarget(self, action: #selector(nameTextFieldDidChange(_:)), for: .editingChanged)
    }
    
    private func setupLink() {
        let attributedString = NSAttributedString(string: NSLocalizedString("SEE_EXAMPLES", comment: ""), attributes:[
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12.0),
            NSAttributedString.Key.foregroundColor : UIColor.gray,
            NSAttributedString.Key.underlineStyle:1.0
        ])
        
        linkButton.setAttributedTitle(attributedString, for: .normal)
    }
    
    func clearTextField() {
        nameInputField.text = ""
        updateNavigationState()
    }
    
    //MARK: Navigation
    
    private func setupNavigation() {
        self.navigationItem.title = NSLocalizedString("BTN_CREATE_COUNTER", comment: "")
        setNavigationLeftButton(withTitle: NSLocalizedString("BTN_CANCEL", comment: ""))
        setNavigationRightButton(withTitle: NSLocalizedString("BTN_SAVE", comment: ""))
        updateNavigationState()
    }
    
    private func updateNavigationState() {
        guard let text = nameInputField.text else {
            updateNavigationRightBarButtonState(enabled: false)
            return
        }
        updateNavigationRightBarButtonState(enabled: !text.withoutWhiteSpaces.isEmpty)
    }
    
    override func handleNavigationLeftBtnClick() {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func handleNavigationRightBtnClick() {
        guard let text = nameInputField.text else {return}
        self.view.endEditing(true)
        showActivityIndicator()
        presenter.saveCounter(withName: text)
    }
    
    //MARK: Action
    
    @IBAction func openExamples(_ sender: Any) {
        let controller = CounterExamplesViewController(delegate: self)
        setNavigationBackButton(withTitle: NSLocalizedString("BTN_CREATE", comment: ""))
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    //MARK: Success Animation
    
    func addSuccessAnimationView() {
        let animation = SuccessAnimation(delegate: self)
        animation.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animation)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            animation.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            animation.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            animation.topAnchor.constraint(equalTo: guide.topAnchor),
            animation.bottomAnchor.constraint(equalTo: guide.bottomAnchor)
        ])
    }
}

//MARK: UITEXTFIELD DELEGATE
extension CreateCounterViewController: UITextFieldDelegate {
    @objc func nameTextFieldDidChange(_ textField: UITextField) {
        updateNavigationState()
    }
    
}

//MARK: PRESENTER DELEGATE
extension CreateCounterViewController: CreateCounterPresenterDelegate {
    func createCounterSuccess() {
        removeActivityIndicator()
        addSuccessAnimationView()
        clearTextField()
    }
    
    func showErrorAlert(withTitle title: String, andMessage message: String, btnTitle: String) {
        removeActivityIndicator()
        showSimpleAlert(withTitle: title, andMessage: message, buttonTitle: btnTitle)
    }
}

//MARK: SUCCESS ANIMATION DELEGATE
extension CreateCounterViewController: SuccessAnimationDelegate {
    func animationDidEnd() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func willRemoveAnimationFromSuperview() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
}

//MARK: EXAMPLES SCREEN DELEGATE
extension CreateCounterViewController: CounterExamplesDelegate {
    func didSelectExample(name: String) {
        self.nameInputField.text = name
        updateNavigationState()
    }
}
