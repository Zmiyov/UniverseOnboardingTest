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
        return label
    }()
    
    lazy var stackView: UIStackView = {
        var stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.alignment = .center
        return stack
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
    }
}
