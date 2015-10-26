//
//  WireframeSpec.swift
//  MyWeather
//
//  Created by Seph Iturralde on 25/10/2015.
//  Copyright © 2015 Epishie. All rights reserved.
//

import UIKit
import Quick
import Nimble
import Swinject
@testable import MyWeather

class RootWireframeSpec: QuickSpec {
    
    override func spec() {
        
        describe("setup root view controller") {
            it("should present the root view controllers") {
                // GIVEN
                let window = UIWindow()
                let wireframe = RootWireframe(window: window)
                
                // WHEN
                wireframe.setupRootViewController()
                
                // THEN
                let navigationViewController = wireframe.window.rootViewController as! UINavigationController
                expect(navigationViewController).toNot(beNil())
                expect(navigationViewController.topViewController).to(beAKindOf(WeatherSearchViewController.self))
                expect(window.keyWindow).to(beTrue())
            }
        }
    }
}