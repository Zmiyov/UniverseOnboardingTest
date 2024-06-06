//
//  BaseOnboardingView.swift
//  UniverseOnboardingTest
//
//  Created by Volodymyr Pysarenko on 05.06.2024.
//

import UIKit

class BaseOnboardingView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstrains()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        backgroundColor = .onboardingBackground
    }
    
    func setupConstrains() {}
}
 
