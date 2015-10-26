//
//  AppDelegate.swift
//  MyWeather
//
//  Created by Seph Iturralde on 25/10/2015.
//  Copyright © 2015 Epishie. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var wireframe: RootWireframe?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        wireframe = RootWireframe(window: window!)
        wireframe?.setupRootViewController()
        return true
    }
}

