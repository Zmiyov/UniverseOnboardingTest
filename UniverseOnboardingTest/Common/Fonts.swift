//
//  Fonts.swift
//  UniverseOnboardingTest
//
//  Created by Vladimir Pisarenko on 05.06.2024.
//

import UIKit

enum Fonts {

    static func onbTitleBold(_ size: CGFloat = 26) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: .bold)
    }
    
    static func onbTitleSemiBold(_ size: CGFloat = 20) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: .semibold)
    }
    
    static func onbTitleMedium(_ size: CGFloat = 16) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: .medium)
    }
    
    static func onbTitleRegular(_ size: CGFloat = 12) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: .regular)
    }
}
