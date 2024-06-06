//
//  OnboardingCollectionViewCell.swift
//  UniverseOnboardingTest
//
//  Created by Volodymyr Pysarenko on 05.06.2024.
//

import UIKit
import SnapKit

final class OnboardingCollectionViewCell: UICollectionViewCell {
    
    private enum Constants {
        static let inset: CGFloat = 16
        static let cornerRadius: CGFloat = 16
        static let titleFontSize: CGFloat = 17
    }
    
    lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.textAlignment = .left
        label.textColor = .blackFont
        label.font = Fonts.onbTitleSemiBold(Constants.titleFontSize)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstrains()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = Constants.cornerRadius
    }
    
    func setupView() {
        backgroundColor = .white
    }
    
    func setupConstrains() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(Constants.inset)
        }
    }
}
