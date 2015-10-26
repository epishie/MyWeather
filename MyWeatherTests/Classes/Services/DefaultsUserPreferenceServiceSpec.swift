//
//  DefaultsUserPreferenceService.swift
//  MyWeather
//
//  Created by Seph Iturralde on 26/10/2015.
//  Copyright © 2015 Epishie. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import MyWeather

class DefaultsUSerPreferenceServiceSpec: QuickSpec {
    
    override func spec() {
        afterEach {
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setValue(nil, forKey: "history")
        }
        describe("getSearchHistory()") {
            it("returns an empty array if actual preference value of \"history\" is nil") {
                // GIVEN
                let defaults = NSUserDefaults.standardUserDefaults()
                defaults.setValue(nil, forKey: "history")
                let service = DefaultsUserPreferenceService()
                
                // WHEN
                let history = service.getSearchHistory()
                
                // THEN
                expect(history).toNot(beNil())
                expect(history.isEmpty).to(beTrue())
            }
            it("returns the correct array of the actual preference value of \"history\"") {
                // GIVEN
                let defaults = NSUserDefaults.standardUserDefaults()
                let savedHistory = ["London", "Madrid", "Paris"]
                defaults.setValue(savedHistory, forKey: "history")
                let service = DefaultsUserPreferenceService()
                
                // WHEN
                let history = service.getSearchHistory()
                
                // THEN
                expect(history).toNot(beNil())
                expect(history).to(equal(savedHistory))
            }
        }
        describe("addSearchHistory()") {
            it("adds the search to preference") {
                // GIVEN
                let defaults = NSUserDefaults.standardUserDefaults()
                defaults.setValue(nil, forKey: "history")
                let service = DefaultsUserPreferenceService()
                
                // WHEN
                service.addSearchHistory("London")
                
                // THEN
                let history = defaults.arrayForKey("history") as? [String]
                expect(history).toNot(beNil())
                expect(history?.count).to(equal(1))
                expect(history?[0]).to(equal("London"))
            }
            it("maintains a maximum count of 10") {
                // GIVEN
                let defaults = NSUserDefaults.standardUserDefaults()
                let savedHistory = ["London", "Madrid", "Paris", "Rome", "Berlin", "Stockholm", "Lisbon", "Dublin", "Amsterdam", "Oslo"]
                defaults.setValue(savedHistory, forKey: "history")
                let service = DefaultsUserPreferenceService()
                
                // WHEN
                service.addSearchHistory("Helsinki")
                
                // THEN
                let history = defaults.arrayForKey("history") as? [String]
                expect(history).toNot(beNil())
                expect(history?.count).to(equal(10))
                expect(history?.first).to(equal("Madrid"))
                expect(history?.last).to(equal("Helsinki"))
            }
            it("does not allow duplicates") {
                let defaults = NSUserDefaults.standardUserDefaults()
                let savedHistory = ["London", "Madrid", "Paris"]
                defaults.setValue(savedHistory, forKey: "history")
                let service = DefaultsUserPreferenceService()
                
                // WHEN
                service.addSearchHistory("Madrid")
                
                // THEN
                let history = defaults.arrayForKey("history") as? [String]
                expect(history).toNot(beNil())
                expect(history?.count).to(equal(3))
                expect(history?[0]).to(equal("London"))
                expect(history?[1]).to(equal("Madrid"))
                expect(history?[2]).to(equal("Paris"))
            }
        }
    }
}