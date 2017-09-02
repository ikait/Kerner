//
//  ViewController.swift
//  KernerSample
//
//  Created by Taishi Ikai on 2017/09/02.
//  Copyright © 2017年 Ikai. All rights reserved.
//

import UIKit
import Kerner

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
                .font: UIFont.systemFont(ofSize: 14),
            ]
        ).bracketsKerned()  // This make kerning to brackets enable 
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
