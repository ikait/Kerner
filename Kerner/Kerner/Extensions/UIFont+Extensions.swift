//
//  UIFont+Extensions.swift
//  Kerner
//
//  Created by Taishi Ikai on 2017/09/02.
//  Copyright © 2017年 Ikai. All rights reserved.
//

import UIKit
import CoreText

public extension UIFont {

    public var altHalf: UIFont {

        let featureSettings: [[UIFontDescriptor.FeatureKey: Int]] = [
            [
                .featureIdentifier: kTextSpacingType,
                .typeIdentifier: kAltHalfWidthTextSelector
            ]
        ]

        var attributes = self.fontDescriptor.fontAttributes

        attributes[.family] = self.familyName.starts(with: ".SF") ? "Hiragino Sans" : self.familyName
        attributes[.featureSettings] = featureSettings

        return UIFont(descriptor: UIFontDescriptor(fontAttributes: attributes),
                      size: self.pointSize)
    }
}
