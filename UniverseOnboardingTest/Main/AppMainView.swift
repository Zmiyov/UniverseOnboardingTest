//
//  AppMainView.swift
//  UniverseOnboardingTest
//
//  Created by Volodymyr Pysarenko on 05.06.2024.
//

import UIKit
import SnapKit

final class AppMainView: BaseOnboardingView {
    
    lazy var imageView: UIImageView = {
        var imageView = UIImageView()
        return imageView
    }()
    
    lazy var label: UILabel = {
        var label = UILabel()
        label.textAlignment = .center
        label.textColor = .blackFont
        label.font = Fonts.onbTitleBold()
        label.text = "Subscribsion isn't active"
        return label
    }()
    
    lazy var stackView: UIStackView = {
        var stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.alignment = .center
        return stack
    }()
    
    lazy var subButton: UIButton = {
        var button = UIButton()
        button.setTitle("Subscribe", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 12
        return button
    }()
    
    override func setupView() {
        super.setupView()
    }
    
    override func setupConstrains() {
        super.setupConstrains()
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(label)
        
        imageView.snp.makeConstraints { make in
            make.size.equalTo(100)
        }
        
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }
        
        addSubview(subButton)
        subButton.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom)
            make.width.equalTo(100)
            make.centerX.equalToSuperview()
        }
    }
}
