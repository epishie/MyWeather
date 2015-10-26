//
//  WeatherSearchWireframeSpec.swift
//  MyWeather
//
//  Created by Seph Iturralde on 26/10/2015.
//  Copyright © 2015 Epishie. All rights reserved.
//

import UIKit
import Quick
import Nimble
import Swinject
@testable import MyWeather

class WeatherSearchWireframeSpec: QuickSpec {
    
    override func spec() {
        describe("presentViewController") {
            it("shows Weather Search View Controller") {
                // GIVEN
                let window = UIWindow()
                let rootWireframe = RootWireframe(window: window)
                let wireframe = rootWireframe.container.resolve(WeatherSearchWireframe.self)!
                wireframe.rootWireframe = rootWireframe
                
                // WHEN
                wireframe.presentViewController()
                
                // THEN
                let navigationViewContoller = window.rootViewController as! UINavigationController
                expect(navigationViewContoller.topViewController).to(equal(wireframe.viewController))
            }
        }
        describe("navigateToDetail") {
            it("transitions to Weather Detail View Controller") {
                // GIVEN
                let window = UIWindow()
                let rootWireframe = RootWireframe(window: window)
                let wireframe = rootWireframe.container.resolve(WeatherSearchWireframe.self)!
                wireframe.rootWireframe = rootWireframe
                wireframe.presentViewController()
                
                // WHEN
                wireframe.navigateToDetail()
                
                // THEN
                let navigationViewContoller = window.rootViewController as! UINavigationController
                expect(navigationViewContoller.topViewController).toEventually(equal(wireframe.detailWireframe?.viewController))
            }
        }
    }
}