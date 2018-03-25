//
//  AppDelegate.swift
//  KernerSample
//
//  Created by Taishi Ikai on 2017/09/02.
//  Copyright © 2017年 Ikai. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        let window = UIWindow(frame: UIScreen.main.bounds)

        let tabVC = UITabBarController()
        tabVC.setViewControllers([
            UINavigationController(rootViewController: ViewController()),
            UINavigationController(rootViewController: TableViewController()),
            UINavigationController(rootViewController: AsyncTableViewController()),
            UINavigationController(rootViewController: WebViewController())
        ], animated: false)

        window.rootViewController = tabVC
        window.makeKeyAndVisible()
        self.window = window

        return true
    }
}
