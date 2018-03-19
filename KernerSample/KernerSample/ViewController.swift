//
//  ViewController.swift
//  KernerSample
//
//  Created by Taishi Ikai on 2017/09/02.
//  Copyright © 2017年 Ikai. All rights reserved.
//

import UIKit
import Kerner

private func getFont(size: CGFloat = UIFont.systemFontSize, weight: UIFont.Weight = .regular) -> UIFont {
    return UIFont(descriptor: UIFontDescriptor(fontAttributes: [
        UIFontDescriptor.AttributeName.family: "Hiragino Sans",
        UIFontDescriptor.AttributeName.traits: [
            UIFontDescriptor.TraitKey.weight: weight.rawValue
        ]
    ]), size: size)
}

class TestView: UIView {

    lazy var paragraphStyle: NSParagraphStyle = {
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .justified
        paragraphStyle.lineSpacing = 0
        return paragraphStyle
    }()

    lazy var attrstr: NSAttributedString = {
        let attrstr = NSMutableAttributedString(
            string: Sample,
            attributes: [
                .foregroundColor: UIColor.black,
                .paragraphStyle: self.paragraphStyle,
                .font: getFont(size: 14)
            ]
        ).kernBrackets()  // This make kerning to brackets enable
        return attrstr
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.init(white: 0.9, alpha: 1)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {

        self.attrstr.draw(in: rect)
    }
}

class ViewController: UIViewController {

    let testView = TestView()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.testView.frame = self.view.frame.insetBy(dx: 10, dy: 10)
        self.view.addSubview(self.testView)
    }
}
