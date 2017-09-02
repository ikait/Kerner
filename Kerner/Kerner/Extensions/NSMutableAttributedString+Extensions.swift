//
//  NSAttributedString+Extensions.swift
//  Kerner
//
//  Created by Taishi Ikai on 2017/09/02.
//  Copyright © 2017年 Ikai. All rights reserved.
//

import UIKit

fileprivate typealias KerningSettings = [(regexp: NSRegularExpression, negativeSpace: CGFloat)]
fileprivate let KerningDefaultNegativeSpaceRatio: CGFloat = 0.5
fileprivate let k句読点 = "、，。．"
fileprivate let k括弧閉 = "｝］」』）｠〉》〕〙】〗"
fileprivate let k括弧開 = "｛［「『（｟〈《〔〘【〖"
fileprivate let k他約物 = "！？：；︰‐・…‥〜ー―※"
fileprivate let defaultFont = UIFont.systemFont(ofSize: UIFont.systemFontSize)

fileprivate let regexpBrackets = try! NSRegularExpression(pattern: "[\(k括弧閉)\(k括弧開)]", options: [])

/**
 For manual settings.
 */
public enum KerningType {

    case all(negativeSpaceRatio: CGFloat)

    case brackets(negativeSpaceRatio: CGFloat)

    fileprivate var setting: KerningSettings {

        switch self {
        case let .all(negativeSpaceRatio):
            return [
                (regexp: try! NSRegularExpression(pattern: "([\(k括弧閉)\(k句読点)])|(.)(?=[\(k括弧開)])", options: []),
                 negativeSpace: 0 - max(negativeSpaceRatio, KerningDefaultNegativeSpaceRatio)),
                (regexp: try! NSRegularExpression(pattern: "([\(k括弧閉)\(k句読点)])(?=[\(k括弧開)])", options: []),
                 negativeSpace: -1 - max(negativeSpaceRatio, KerningDefaultNegativeSpaceRatio) * 2)
            ]
        case let .brackets(negativeSpaceRatio):
            return [
                (regexp: try! NSRegularExpression(pattern: "([\(k括弧閉)])|(.)(?=[\(k括弧開)])", options: []),
                 negativeSpace: 0 - negativeSpaceRatio),
                (regexp: try! NSRegularExpression(pattern: "([\(k括弧閉)])(?=[\(k括弧開)])", options: []),
                 negativeSpace: 0 - max(negativeSpaceRatio, KerningDefaultNegativeSpaceRatio) * 2)
            ]
        }
    }
}

public extension NSMutableAttributedString {

    @discardableResult
    private func kern(_ regexp: NSRegularExpression, negativeSpace: CGFloat = 0 - KerningDefaultNegativeSpaceRatio) -> Self {
        self.beginEditing()
        regexp.enumerateMatches(in: self.string, options: [], range: NSMakeRange(0, self.length)) { [weak self] (result, _, _) in
            guard let result = result, let `self` = self else { return }
            let (location, length) = (result.range.location, result.range.length)
            let curAttrs = self.attributes(at: location, effectiveRange: nil)
            let font = curAttrs[.font] as? UIFont ?? defaultFont
            self.addAttribute(.kern, value: font.pointSize * negativeSpace, range: NSMakeRange(location, length))
        }
        self.endEditing()
        return self
    }

    public func kern(with type: KerningType) -> Self {
        type.setting.forEach { args in
            self.kern(args.regexp, negativeSpace: args.negativeSpace)
        }
        return self
    }

    @discardableResult
    public func kernBrackets() -> Self {
        self.beginEditing()
        regexpBrackets.enumerateMatches(in: self.string, options: [], range: NSMakeRange(0, self.length)) { [weak self] (result, _, _) in
            guard let result = result, let `self` = self else { return }
            let (location, length) = (result.range.location, result.range.length)
            let curAttrs = self.attributes(at: location, effectiveRange: nil)
            let font = curAttrs[.font] as? UIFont ?? defaultFont
            self.addAttribute(.font, value: font.altHalf, range: NSMakeRange(location, length))
        }
        self.endEditing()
        return self
    }

    public func clearKerning(with range: NSRange) -> Self {
        self.removeAttribute(.kern, range: range)
        return self
    }
}
