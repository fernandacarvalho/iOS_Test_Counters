//
//  GenericPlaceholderView.swift
//  Counters
//
//  Created by Fernanda FC. Carvalho on 19/06/21.
//

import UIKit

class GenericPlaceholderView: UIControl {
    // MARK: - Properties
    
    private let stackView = UIStackView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let actionButton = Button()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setups
    
    fileprivate func setup() {
        backgroundColor = .background
        setupStackView()
        setupTitleLabel()
        setupSubtitleLabel()
        setupButton()
        setupViewHierarchy()
        setupConstraints()
    }
    
    fileprivate func setupStackView() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = Constants.spacing
        stackView.alignment = .center
    }
    
    fileprivate func setupTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFontMetrics(forTextStyle: .title1).scaledFont(for: Font.title)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
    }
    
    fileprivate func setupSubtitleLabel() {
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: Font.description)
        subtitleLabel.numberOfLines = 0
        subtitleLabel.lineBreakMode = .byWordWrapping
        subtitleLabel.textAlignment = .center
        subtitleLabel.textColor = UIColor.subtitleText
    }
    
    fileprivate func setupButton() {
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        actionButton.addTarget(self, action: #selector(tryAgain), for: .touchUpInside)
        actionButton.clipsToBounds = false
    }
    
    fileprivate func setupViewHierarchy() {
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subtitleLabel)
        stackView.addArrangedSubview(actionButton)
        self.addSubview(stackView)
    }
    
    fileprivate func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor),
            stackView.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, constant: -(Constants.margin))
        ])
    }
    
    // MARK: - Actions
    
    @objc func tryAgain() {
        self.sendActions(for: .primaryActionTriggered)
    }
    
}

private extension GenericPlaceholderView {
    enum Constants {
        static let spacing: CGFloat = 24
        static let margin: CGFloat = 15
        static let buttonHeight: CGFloat = 57
    }
    
    enum Font {
        static let kern: CGFloat = 0.34
        static let title = UIFont.systemFont(ofSize: 21, weight: .bold)
        static let description = UIFont.systemFont(ofSize: 17, weight: .regular)
    }
}

extension GenericPlaceholderView {
    public func setInfo(with title: String, subtitle: String, btnTitle: String) {
        self.titleLabel.text = title
        self.subtitleLabel.text = subtitle
        self.actionButton.setTitle(btnTitle, for: .normal)
        self.layoutSubviews()
        self.updateConstraints()
    }
}
