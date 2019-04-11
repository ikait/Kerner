//
//  UIFont+Extensions.swift
//  Kerner
//
//  Created by Taishi Ikai on 2017/09/02.
//  Copyright © 2017年 Ikai. All rights reserved.
//

import UIKit
import CoreText

private let featureSettings: [[UIFontDescriptor.FeatureKey: Int]] = [
    [
        .featureIdentifier: kTextSpacingType,
        .typeIdentifier: kAltHalfWidthTextSelector
    ]
]

public extension UIFont {

    private final var systemAltHalf: UIFont {

        let weight: UIFont.Weight = {

            var weight = UIFont.Weight.regular

            let usageAttribute = self.fontDescriptor.fontAttributes[
                .init(rawValue: "NSCTFontUIUsageAttribute")] as? String ?? ""

            switch usageAttribute {
            case "CTFontEmphasizedUsage", "CTFontBoldUsage":
                weight = .bold
            case "CTFontDemiUsage":
                weight = .bold
            default:
                break
            }

            return weight
        }()

        let familyName = "Hiragino Sans"

        let pointSize = self.pointSize - 1

        let traits: [UIFontDescriptor.TraitKey: CGFloat] = [
            .weight: weight.rawValue
        ]

        let fontDescriptor = UIFontDescriptor(fontAttributes: [
            .family: familyName,
            .traits: traits,
            .featureSettings: featureSettings,
        ])

        return UIFont(descriptor: fontDescriptor, size: pointSize)
    }

    final var altHalf: UIFont {

        if self.familyName.starts(with: ".SF") {
            return self.systemAltHalf
        }

        var attributes = self.fontDescriptor.fontAttributes

        attributes[.featureSettings] = featureSettings

        return UIFont(descriptor: UIFontDescriptor(fontAttributes: attributes), size: self.pointSize)
    }
}
