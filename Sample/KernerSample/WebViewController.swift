//
//  WebViewController.swift
//  KernerSample
//
//  Created by Taishi Ikai on 2017/09/30.
//  Copyright © 2017年 Ikai. All rights reserved.
//

import UIKit
import WebKit

final class WebViewController: UIViewController {

    var reloadButton = UIBarButtonItem()

    lazy var htmlString: String = {
        guard let htmlFile = Bundle.main.path(forResource: "sample", ofType: "html") else {
            return ""
        }
        return (try? String(contentsOfFile: htmlFile)) ?? ""
    }()

    lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.configuration.preferences.setValue(true, forKey: "developerExtrasEnabled")
        return webView
    }()

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {

        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        self.title = "Web View"
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {

        super.viewDidLoad()

        self.view.addSubview(self.webView)
        self.webView.bindFrameToSuperviewBounds()

        self.reloadButton.action = #selector(self.loadHTML)

        self.loadHTML()
    }

    func didTapReloadButton(sender: UIBarButtonItem) {
        self.loadHTML()
    }

    @objc func loadHTML() {
        self.webView.loadHTMLString(self.htmlString.markedForKerningHTMLString, baseURL: nil)
    }
}

extension UIView {
    func bindFrameToSuperviewBounds() {
        guard let superview = self.superview else {
            return
        }

        self.translatesAutoresizingMaskIntoConstraints = false
        superview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[subview]-0-|", options: .directionLeadingToTrailing, metrics: nil, views: ["subview": self]))
        superview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[subview]-0-|", options: .directionLeadingToTrailing, metrics: nil, views: ["subview": self]))
    }
}
