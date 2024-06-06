//
//  PaywallView.swift
//  UniverseOnboardingTest
//
//  Created by Vladimir Pisarenko on 05.06.2024.
//

import UIKit
import SnapKit

final class PaywallView: BaseOnboardingView {
    
    lazy var topImage: UIImageView = {
        var imageView = UIImageView()
        imageView.image = UIImage(named: "paywallImage")
        return imageView
    }()
    
    lazy var closeButton: UIButton = {
        var button = UIButton()
        button.setImage(UIImage(named: "close"), for: .normal)
        return button
    }()
    
    lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.textAlignment = .left
        label.textColor = .blackFont
        label.font = Fonts.onbTitleBold()
        label.text = PaywallScreenTxt.title
        label.numberOfLines = 0
        return label
    }()
    
    lazy var trialTermsLabel: UILabel = {
        var label = UILabel()
        label.textAlignment = .left
        label.textColor = .paywallTextGray
        label.font = Fonts.onbTitleMedium(16)
        label.numberOfLines = 0
        return label
    }()
    
    lazy var startButton: UIButton = {
        var button = UIButton()
        button.backgroundColor = .buttonBlack
        button.setTitle(PaywallScreenTxt.buttonTitle, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = Fonts.onbTitleSemiBold(17)
        return button
    }()
    
    lazy var privacyTermsTextView: UITextView = {
        var textView = UITextView()
        textView.isEditable = false
        textView.backgroundColor = .clear
        textView.textAlignment = .center
        textView.textColor = .paywallTextGray
        textView.font = Fonts.onbTitleRegular()
        textView.text = PaywallScreenTxt.termsTitle
        return textView
    }()
    
    lazy var indicator: UIActivityIndicatorView = {
        let indicator: UIActivityIndicatorView = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.color = .white
        indicator.isHidden = true
        return indicator
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        startButton.layer.cornerRadius = startButton.frame.height / 2
        startButton.drawShadow(destination: .button)
    }
    
    override func setupView() {
        super.setupView()
        
        setupAttributedTextView()
    }
    
    func setupAttributedLabel(price: String) {
        let text = "Try 7 days for free \nthen \(price) per week, auto-renewable"
        let attributedString = NSMutableAttributedString(string: text)
        
        let boldRange = (text as NSString).range(of: price)
        attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 16), range: NSRange(location: 0, length: text.count))
        attributedString.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 16), range: boldRange)
        attributedString.addAttribute(.foregroundColor, value: UIColor.blackFont, range: boldRange)
        
        trialTermsLabel.attributedText = attributedString
    }
    
    private func setupAttributedTextView() {
        privacyTermsTextView.addHyperLinksToText(originalText: PaywallScreenTxt.termsTitle,
                                                 hyperLinks: ["Terms of Use" : "https://www.apple.com",
                                                              "Privacy Policy" : "https://www.google.com",
                                                              "Subscription Terms" : "https://www.amazon.com"])
    }
    
    override func setupConstrains() {
        super.setupConstrains()
        
        enum Constants {
            static let bottomInset: CGFloat = 82
            static let horizontalInset: CGFloat = 24
            static let collectionVerticalInset: CGFloat = 20
            static let titleLabelHeight: CGFloat = 30
            static let pageNameLabelTopInset: CGFloat = 30
            static let pageNameLabelHeight: CGFloat = 24
            static let continueButtonHeight: CGFloat = 56
        }
        
        addSubview(topImage)
        topImage.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(self.snp.centerY)
        }
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(topImage.snp.bottom).offset(40)
            make.horizontalEdges.equalToSuperview().inset(Constants.horizontalInset)
        }
        
        addSubview(trialTermsLabel)
        trialTermsLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(40)
            make.horizontalEdges.equalToSuperview().inset(Constants.horizontalInset)
        }
        
        addSubview(startButton)
        startButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(Constants.horizontalInset)
            make.bottom.equalToSuperview().inset(Constants.bottomInset)
            make.height.equalTo(Constants.continueButtonHeight)
        }
        
        addSubview(privacyTermsTextView)
        privacyTermsTextView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(Constants.horizontalInset)
            make.top.equalTo(startButton.snp.bottom).offset(10)
            make.bottom.equalToSuperview()
        }
        
        addSubview(closeButton)
        closeButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.size.equalTo(24)
        }
        
        addSubview(indicator)
        indicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
    }
}
