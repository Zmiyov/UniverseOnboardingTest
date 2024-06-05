//
//  OnboardingView.swift
//  UniverseOnboardingTest
//
//  Created by Vladimir Pisarenko on 05.06.2024.
//

import UIKit
import SnapKit

final class OnboardingView: BaseOnboardingView {
    
    lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.textAlignment = .left
        label.textColor = .blackFont
        label.font = Fonts.onbTitle()
        label.text = "Test title"
        return label
    }()
    
    lazy var pageNameLabel: UILabel = {
        var label = UILabel()
        label.textAlignment = .left
        label.textColor = .blackFont
        label.font = Fonts.onbPageTitle()
        label.text = "Test page title"
        return label
    }()
    
    lazy var onbCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(OnboardingCollectionViewCell.self)
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    lazy var continueButton: UIButton = {
        var button = UIButton()
        button.backgroundColor = .buttonBlack
        button.setTitle("Continue", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = Fonts.onbButtonTitle()
        return button
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        continueButton.layer.cornerRadius = continueButton.frame.height / 2
        continueButton.drawShadow(destination: .button)
    }
    
    override func setupView() {
        super.setupView()
        
    }
    
    override func setupConstrains() {
        super.setupConstrains()
        
        enum Constants {
            static let topInset: CGFloat = 104
            static let bottomInset: CGFloat = 82
            static let horizontalInset: CGFloat = 24
            static let collectionVerticalInset: CGFloat = 20
            static let titleLabelHeight: CGFloat = 30
            static let pageNameLabelTopInset: CGFloat = 30
            static let pageNameLabelHeight: CGFloat = 24
            static let continueButtonHeight: CGFloat = 56
        }
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Constants.topInset)
            make.height.equalTo(Constants.titleLabelHeight)
            make.horizontalEdges.equalToSuperview().inset(Constants.horizontalInset)
        }
        
        addSubview(pageNameLabel)
        pageNameLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Constants.pageNameLabelTopInset)
            make.horizontalEdges.equalToSuperview().inset(Constants.horizontalInset)
            make.height.equalTo(Constants.pageNameLabelHeight)
        }
        
        addSubview(continueButton)
        continueButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(Constants.horizontalInset)
            make.bottom.equalToSuperview().inset(Constants.bottomInset)
            make.height.equalTo(Constants.continueButtonHeight)
        }
        
        addSubview(onbCollectionView)
        onbCollectionView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(Constants.horizontalInset)
            make.top.equalTo(pageNameLabel.snp.bottom).offset(Constants.collectionVerticalInset)
            make.bottom.equalTo(continueButton.snp.top).inset(-Constants.collectionVerticalInset)
        }
        
    }
}
