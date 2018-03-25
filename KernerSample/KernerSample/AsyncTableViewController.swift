//
//  AsyncTableViewController.swift
//  KernerSample
//
//  Created by Taishi Ikai on 2018/03/25.
//  Copyright © 2018年 Ikai. All rights reserved.
//

import AsyncDisplayKit

class TextNode: ASDisplayNode {

    var attributedText: NSAttributedString?

    private var layerImage: CGImage?

    override init() {

        super.init()

        self.isLayerBacked = true

        self.automaticallyManagesSubnodes = true
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {

        guard let boundingRect = self.attributedText?.boundingRect(with: constrainedSize.min,
                                                                   options: drawingOptions,
                                                                   context: nil).integral else {
            return ASLayoutSpec()
        }

        let contextSize = CGSize(width: constrainedSize.min.width, height: boundingRect.height)

        UIGraphicsBeginImageContextWithOptions(contextSize, false, 0)

        let context = UIGraphicsGetCurrentContext()

        self.attributedText?.draw(with: CGRect(origin: .zero, size: boundingRect.size),
                                  options: drawingOptions,
                                  context: nil)

        self.layerImage = context?.makeImage()

        UIGraphicsEndImageContext()

        let layoutSpec = ASLayoutSpec()
        layoutSpec.style.preferredSize = boundingRect.size

        return layoutSpec
    }

    override func didEnterDisplayState() {

        super.didEnterDisplayState()

        self.contents = self.layerImage
    }
}


final class CellNode: ASCellNode {

    static let paragraphStyle: NSParagraphStyle = {
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 0
        paragraphStyle.alignment = .justified
        return paragraphStyle
    }()

    lazy var textNode: TextNode = {

        let node = TextNode()

        return node
    }()

    override init() {

        super.init()

        self.automaticallyManagesSubnodes = true
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {

        return ASWrapperLayoutSpec(layoutElement: self.textNode)
    }

    override func didLoad() {

    }

    override func layout() {

    }
}

extension CellNode {

    func configure(with text: String) {

        self.textNode.attributedText = NSMutableAttributedString(
            string: text,
            attributes: [
                .foregroundColor: UIColor.black,
                .paragraphStyle: type(of: self).paragraphStyle,
                .font: UIFont(name: "Hiragino Sans", size: 18)!
            ]
        ).kernBrackets()
    }
}

final class AsyncTableViewController: ASViewController<ASTableNode> {

    lazy var tableNode: ASTableNode = {

        let node = ASTableNode()
        node.delegate = self
        node.dataSource = self

        return node
    }()

    init() {

        super.init(node: self.tableNode)

        self.title = "Async Table"
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {

        super.viewDidLoad()
    }
}

extension AsyncTableViewController: ASTableDelegate {}

extension AsyncTableViewController: ASTableDataSource {

    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {

        return {
            let node = CellNode()
            node.configure(with: Sentences[indexPath.row % Sentences.count])
            return node
        }
    }

    func numberOfSections(in tableNode: ASTableNode) -> Int {

        return 1
    }

    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {

        return 1000
    }
}
