//
//  WelcomeViewPresenter.swift
//  Counters
//
//

import UIKit

internal final class WelcomeViewPresenter {
    private let features: [WelcomeFeatureView.ViewModel] = [
        .init(
            badge: UIImage.badge(sytemIcon: "42.circle.fill",
                                 color: UIColor.red),
            title: NSLocalizedString("WELCOME_ADD_FEATURE_TITLE", comment: ""),
            subtitle: NSLocalizedString("WELCOME_ADD_FEATURE_DESCRIPTION", comment: "")
        ),
        .init(
            badge: UIImage.badge(sytemIcon: "person.2.fill",
                                 color: UIColor.yellow),
            title: NSLocalizedString("WELCOME_COUNT_SHARE_FEATURE_TITLE", comment: ""),
            subtitle: NSLocalizedString("WELCOME_COUNT_SHARE_FEATURE_DESCRIPTION", comment: "")
        ),
        .init(
            badge: UIImage.badge(sytemIcon: "lightbulb.fill",
                                 color: UIColor.green),
            title: NSLocalizedString("WELCOME_COUNT_FEATURE_TITLE", comment: ""),
            subtitle: NSLocalizedString("WELCOME_COUNT_FEATURE_DESCRIPTION", comment: "")
        )]
}

extension WelcomeViewPresenter: WelcomeViewControllerPresenter {
    var viewModel: WelcomeView.ViewModel {
        
        let welcome = NSMutableAttributedString(string: NSLocalizedString("WELCOME_TITLE", comment: ""))
        let range = (welcome.string as NSString).range(of: NSLocalizedString("APP_NAME", comment: ""))
        if range.location != NSNotFound {
            welcome.setAttributes([.foregroundColor: UIColor.accentColor], range: range)
        }
        
        return .init(title: welcome,
                     description: NSLocalizedString("WELCOME_DESCRIPTION", comment: ""),
                     features: features,
                     buttonTitle: NSLocalizedString("WELCOME_PRIMARY_ACTION_TITLE", comment: ""))
    }
}
