//
//  UIView+shadow.swift
//  UniverseOnboardingTest
//
//  Created by Volodymyr Pysarenko on 05.06.2024.
//

import UIKit

enum ShadowDestination {
    case button
    case cell
}

extension UIView {
    func drawShadow(destination: ShadowDestination) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.shadowGray.cgColor
        layer.shadowOpacity = 0.25
        layer.shadowRadius = 15

        switch destination {
        case .button:
            layer.shadowOffset = CGSize(width: 0 , height: 3)
        case .cell:
            layer.shadowOffset = CGSize(width: 0 , height: 1)
        }
    }
}
