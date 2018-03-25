//
//  TableViewController.swift
//  KernerSample
//
//  Created by Taishi Ikai on 2017/09/02.
//  Copyright © 2017年 Ikai. All rights reserved.
//

import UIKit

let drawingOptions: NSStringDrawingOptions = [
    .usesLineFragmentOrigin,
    .truncatesLastVisibleLine
]

final class CellView: UIView {

    var paragraphStyle: NSParagraphStyle = {
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 0
        paragraphStyle.alignment = .justified
        return paragraphStyle
    }()

    var attrstr = NSAttributedString()

    var text: String = "" {
        didSet {
            self.attrstr = NSMutableAttributedString(
                string: self.text,
                attributes: [
                    .foregroundColor: UIColor.black,
                    .paragraphStyle: paragraphStyle,
                    .font: UIFont(name: "Hiragino Sans", size: 18)!
                ]
            ).kernBrackets()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.drawsAsynchronously = true
        self.backgroundColor = .white
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @discardableResult
    static func draw(_ attributedString: NSAttributedString, in rect: CGRect) -> CGImage? {
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        UIGraphicsPushContext(context)
        attributedString.draw(with: rect.integral, options: drawingOptions, context: nil)
        let image = context.makeImage()
        UIGraphicsEndImageContext()
        return image
    }
}

class TableViewCell: UITableViewCell {

    let cellView = CellView(frame: .zero)

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {

        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.contentView.addSubview(self.cellView)
    }

    required init?(coder aDecoder: NSCoder) {

        super.init(coder: aDecoder)
    }

    override func layoutSubviews() {

        self.cellView.frame = self.bounds

        let bounds = self.bounds
        let attributedString = cellView.attrstr

        DispatchQueue.global().async {
            UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0)
            guard let image = CellView.draw(attributedString, in: bounds) else {
                return
            }
            DispatchQueue.main.async {
                self.cellView.layer.contents = image
                super.layoutSubviews()
            }
        }
    }
}

class TableViewController: UITableViewController {

    let heightCache = Cache<IndexPath, CGFloat>()

    init() {

        super.init(nibName: nil, bundle: nil)

        self.title = "Table"
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {

        self.tableView.register(TableViewCell.self, forCellReuseIdentifier: "cell")

        super.viewDidLoad()
        self.tableView.estimatedRowHeight = 0
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1000
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let view = CellView(frame: .zero)
        view.text = Sentences[indexPath.row % Sentences.count]

        if let height = self.heightCache.object(forKey: indexPath) {
            return height
        }
        let rect = view.attrstr.boundingRect(with: tableView.frame.integral.size,
                                             options: drawingOptions,
                                             context: nil).integral
        self.heightCache.setObject(rect.height, forKey: indexPath)
        return rect.height
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell

        cell.cellView.text = Sentences[indexPath.row % Sentences.count]
        cell.cellView.setNeedsDisplay()

        return cell
    }
}
