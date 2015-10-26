//
//  AppDelegateSpec.swift
//  MyWeather
//
//  Created by Seph Iturralde on 25/10/2015.
//  Copyright © 2015 Epishie. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import MyWeather

class AppDelegateSpec: QuickSpec {
    
    override func spec() {
        describe("didFinishLaunchingWithOptions") {
            it("create root wireframe") {
                // GIVEN
                let appDelegate = AppDelegate()
                
                // WHEN
                appDelegate.application(UIApplication.sharedApplication(), didFinishLaunchingWithOptions: nil)
                
                // THEN
                expect(appDelegate.wireframe).toNot(beNil())
                expect(appDelegate.wireframe?.window).to(equal(appDelegate.window))
            }
        }
    }
}