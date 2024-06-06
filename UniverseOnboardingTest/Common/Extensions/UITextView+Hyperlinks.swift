//
//  UILabel+Hyperlinks.swift
//  UniverseOnboardingTest
//
//  Created by Volodymyr Pysarenko on 05.06.2024.
//

import UIKit

extension UITextView {

  func addHyperLinksToText(originalText: String, hyperLinks: [String: String]) {
    let style = NSMutableParagraphStyle()
    style.alignment = .center
      
    let attributedOriginalText = NSMutableAttributedString(string: originalText)
    for (hyperLink, urlString) in hyperLinks {
        let linkRange = attributedOriginalText.mutableString.range(of: hyperLink)
        let fullRange = NSRange(location: 0, length: attributedOriginalText.length)
        attributedOriginalText.addAttribute(.foregroundColor, value: UIColor.paywallTextGray, range: fullRange)
        attributedOriginalText.addAttribute(NSAttributedString.Key.link, value: urlString, range: linkRange)
        attributedOriginalText.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: fullRange)
        attributedOriginalText.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 12, weight: .regular), range: fullRange)
    }

    self.attributedText = attributedOriginalText
  }
}
