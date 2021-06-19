//
//  AppDelegate.swift
//  Counters
//
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        self.setWelcomeScreen()
        return true
    }
    
    func setWelcomeScreen() {
        let window = UIWindow()
        let presenter = WelcomeViewPresenter()
        window.rootViewController = WelcomeViewController(presenter: presenter)
        self.window = window
        window.makeKeyAndVisible()
    }
    
    func changeRootToHome(withTransition: Bool) {
        guard let window = self.window else {
            return
        }
        let navigation = MainNavigationController(rootViewController: CountersListViewController())
        window.rootViewController = navigation
        if withTransition {
            self.addTransitions()
        }
    }
    
    private func addTransitions() {
        let options: UIView.AnimationOptions = .transitionCrossDissolve
        let duration: TimeInterval = 0.3
        UIView.transition(with: self.window!, duration: duration, options: options, animations: {}, completion:
                            { completed in
                            })
    }
}

