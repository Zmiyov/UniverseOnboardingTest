//
//  PaywallView.swift
//  UniverseOnboardingTest
//
//  Created by Volodymyr Pysarenko on 05.06.2024.
//

import UIKit
import SnapKit

final class PaywallView: BaseOnboardingView {
    
    private enum PaywallViewConstants {
        static let termsFontSize: CGFloat = 16
        static let startButtonTitleFontSize: CGFloat = 17
    }
    
    lazy var topImage: UIImageView = {
        var imageView = UIImageView()
        imageView.image = UIImage(named: "paywallImage")
        imageView.contentMode = .scaleAspectFill
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
        label.numberOfLines = 0
        return label
    }()
    
    lazy var startButton: UIButton = {
        var button = UIButton()
        button.backgroundColor = .buttonBlack
        button.setTitle(PaywallScreenTxt.buttonTitle, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = Fonts.onbTitleSemiBold(PaywallViewConstants.startButtonTitleFontSize)
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
        attributedString.addAttribute(.font, value: Fonts.onbTitleMedium(PaywallViewConstants.termsFontSize), range: NSRange(location: 0, length: text.count))
        attributedString.addAttribute(.font, value: Fonts.onbTitleBold(PaywallViewConstants.termsFontSize), range: boldRange)
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
            static let closeButtonSize: CGFloat = 24
            static let closeButtonTrailing: CGFloat = 16
            static let titleLabelTopInset: CGFloat = 40
            static let trialTermsLabelTopInset: CGFloat = 16
            static let privacyTermsTextViewTopInset: CGFloat = 10
            static let horizontalInset: CGFloat = 24
            static let startButtonHeight: CGFloat = 56
            static let startButtonBottomInset: CGFloat = 82
        }
        
        addSubview(topImage)
        topImage.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(self.snp.centerY)
        }
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(topImage.snp.bottom).offset(Constants.titleLabelTopInset)
            make.horizontalEdges.equalToSuperview().inset(Constants.horizontalInset)
        }
        
        addSubview(trialTermsLabel)
        trialTermsLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Constants.trialTermsLabelTopInset)
            make.horizontalEdges.equalToSuperview().inset(Constants.horizontalInset)
        }
        
        addSubview(startButton)
        startButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(Constants.horizontalInset)
            make.bottom.equalToSuperview().inset(Constants.startButtonBottomInset)
            make.height.equalTo(Constants.startButtonHeight)
        }
        
        addSubview(privacyTermsTextView)
        privacyTermsTextView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(Constants.horizontalInset)
            make.top.equalTo(startButton.snp.bottom).offset(Constants.privacyTermsTextViewTopInset)
            make.bottom.equalToSuperview()
        }
        
        addSubview(closeButton)
        closeButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(Constants.closeButtonTrailing)
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.size.equalTo(Constants.closeButtonSize)
        }
    }
}
