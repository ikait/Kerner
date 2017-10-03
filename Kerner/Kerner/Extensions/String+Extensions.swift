//
//  String+Extensions.swift
//  Kerner
//
//  Created by Taishi Ikai on 2017/09/30.
//  Copyright © 2017年 Ikai. All rights reserved.
//

import Foundation

fileprivate func re(_ pattern: String) -> NSRegularExpression {
    return try! NSRegularExpression(pattern: pattern, options: [])
}

fileprivate let kPatternSettings: [(pattern: NSRegularExpression, template: String)] = [
    (
        // 括弧の両脇に空白を入れる
        pattern: re("([\(k括弧閉)])(.)([\(k括弧開)])"),
        template: "<span class=\"__kerner_pad_right\">$1$2</span>$3"
    ),
    (
        // 括弧の左に空白を入れる
        pattern: re("([^\(k記号)\(k句読点)\(k括弧開)\(k括弧閉)\\s]+?)([\(k括弧開)])"),
        template: "<span class=\"__kerner_pad_right\">$1</span>$2"
    ),
    (
        // 括弧の右に空白を入れる
        pattern: re("([\(k括弧閉)])([^\(k記号)\(k句読点)\(k括弧開)\(k括弧閉)\\s]+?)"),
        template: "<span class=\"__kerner_pad_right\">$1</span>$2"
    ),
    (
        pattern: re("([\(k括弧開)])"),
        template: "<span class=\"__kerner_kern_left\">$1</span>"
    ),
    (
        pattern: re("([\(k括弧閉)])"),
        template: "<span class=\"__kerner_kern_right\">$1</span>"
    )
]

public extension String {

    public var markedForKerningHTMLString: String {

        let target = NSMutableString(string: self)

        kPatternSettings.forEach { args in
            args.pattern.replaceMatches(in: target,
                                        options: [],
                                        range: NSMakeRange(0, target.length),
                                        withTemplate: args.template)
        }

        return target as String
    }
}
