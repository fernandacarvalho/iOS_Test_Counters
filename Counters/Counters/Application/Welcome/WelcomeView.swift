//
//  WelcomeView.swift
//  Counters
//
//

import UIKit

internal final class WelcomeView: UIView {
    // MARK: - View Model
    
    struct ViewModel {
        let title: NSAttributedString
        let description: String
        let features: [WelcomeFeatureView.ViewModel]
        let buttonTitle: String
    }
    
    // MARK: - Properties
    
    private let scrollView = UIScrollView()
    private let scrollContentView = UIView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let stackView = UIStackView()
    private let button = Button()
    
    // MARK: - Initialization
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration
    
    func configure(with viewModel: ViewModel) {
        titleLabel.attributedText = viewModel.title
        subtitleLabel.attributedText = .init(string: viewModel.description,
                                             attributes: [.kern: Font.kern])
        
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        viewModel.features.forEach {
            let view = WelcomeFeatureView()
            view.configure(with: $0)
            stackView.addArrangedSubview(view)
        }
        
        button.setTitle(viewModel.buttonTitle, for: .normal)
    }
}

// MARK: - Private Constants

private extension WelcomeView {
    enum Constants {
        static let spacing: CGFloat = 24
        static let buttonHeight: CGFloat = 57
        static let stackViewTopMargin: CGFloat = 45
        static let stackViewBottomMargin: CGFloat = 45
    }
    
    enum Font {
        static let kern: CGFloat = 0.34
        static let title = UIFont.systemFont(ofSize: 33, weight: .heavy)
        static let description = UIFont.systemFont(ofSize: 17, weight: .regular)
    }
    
    enum Shadow {
        static let opacity: Float = 1
        static let radius: CGFloat = 16
        static let offset = CGSize(width: 0, height: 8)
        static let color = UIColor(white: 0, alpha: 0.1).cgColor
    }
}

// MARK: - Private Implementation

private extension WelcomeView {
    func setup() {
        backgroundColor = .systemBackground
        
        setupScrollView()
        setupTitleLabel()
        setupSubtitleLabel()
        setupStackView()
        setupButton()
        setupViewHierarchy()
        setupConstraints()
    }
    
    func setupScrollView() {
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.scrollContentView.translatesAutoresizingMaskIntoConstraints = false
        self.scrollView.backgroundColor = .clear
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollContentView.backgroundColor = .clear
    }
    
    func setupTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFontMetrics(forTextStyle: .largeTitle).scaledFont(for: Font.title)
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        if #available(iOS 14.0, *) {
            /// used to leave the `Counters` as an Orphaned Word
            titleLabel.lineBreakStrategy = .hangulWordPriority
        }
    }
    
    func setupSubtitleLabel() {
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: Font.description)
        subtitleLabel.numberOfLines = 0
        subtitleLabel.textColor = UIColor.subtitleText
    }
    
    func setupStackView() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = Constants.spacing
        stackView.alignment = .top
    }
    
    func setupButton() {
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didPressContinue), for: .touchUpInside)
        
        button.clipsToBounds = false
        button.layer.shadowRadius = Shadow.radius
        button.layer.shadowColor = Shadow.color
        button.layer.shadowOffset = Shadow.offset
        button.layer.shadowOpacity = Shadow.opacity
    }
    
    func setupViewHierarchy() {
        self.scrollView.addSubview(self.scrollContentView)
        self.scrollContentView.addSubview(titleLabel)
        self.scrollContentView.addSubview(subtitleLabel)
        self.scrollContentView.addSubview(stackView)
        self.scrollContentView.addSubview(button)
        self.addSubview(self.scrollView)
    }
    
    func setupConstraints() {
        let guide = safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            //scrollView
            scrollView.topAnchor.constraint(equalTo: guide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
            
            //contentView
            scrollContentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            scrollContentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            scrollContentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            scrollContentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            scrollContentView.widthAnchor.constraint(equalTo: guide.widthAnchor),
            
            // title label
            titleLabel.topAnchor.constraint(equalTo: scrollContentView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor),
            
            // subtitle label
            subtitleLabel.topAnchor.constraint(
                equalTo: titleLabel.bottomAnchor,
                constant: Constants.spacing
            ),
            subtitleLabel.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor),
            
            // stack view
            stackView.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor),
            stackView.topAnchor.constraint(
                equalTo: subtitleLabel.bottomAnchor,
                constant: Constants.stackViewTopMargin
            ),
            
            // button
            button.heightAnchor.constraint(
                equalToConstant: Constants.buttonHeight
            ),
            button.topAnchor.constraint(
                greaterThanOrEqualTo: stackView.bottomAnchor,
                constant: Constants.stackViewBottomMargin
            ),
            button.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor),
            button.bottomAnchor.constraint(equalTo: scrollContentView.bottomAnchor)
        ])
    }
}

private extension WelcomeView {
    @objc func didPressContinue() {
        
    }
}
