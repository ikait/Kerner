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

class CellView: UIView {

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
                    .font: UIFont.systemFont(ofSize: 14)
                ]
            ).bracketKerned()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.drawsAsynchronously = true
        self.backgroundColor = .white
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = .white
    }

    override func draw(_ rect: CGRect) {
        self.attrstr.draw(with: CGRect.init(x: 0, y: 0, width: rect.width, height: CGFloat.greatestFiniteMagnitude).integral,
                          options: drawingOptions,
                          context: nil)
    }
}

class TableViewCell: UITableViewCell {

    @IBOutlet weak var cellView: CellView!

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class TableViewController: UITableViewController {

    var images: [IndexPath: CGImage] = [:]

    override func viewDidLoad() {
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
        let view = CellView()
        view.text = Sentences[indexPath.row % Sentences.count]
        let rect = view.attrstr.boundingRect(with: tableView.frame.integral.size,
                                             options: drawingOptions,
                                             context: nil).integral
        return rect.height
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell

        cell.cellView.text = Sentences[indexPath.row % Sentences.count]
        cell.cellView.setNeedsDisplay()

        return cell
    }
}
