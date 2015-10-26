//
//  WeatherSearchViewControllerSpec.swift
//  MyWeather
//
//  Created by Seph Iturralde on 26/10/2015.
//  Copyright © 2015 Epishie. All rights reserved.
//

import UIKit
import Quick
import Nimble
@testable import MyWeather

class WeatherSearchViewControllerSpec: QuickSpec {
    
    override func spec() {
        describe("viewDidLoad") {
            it("should add a UISearchBar") {
                // GIVEN
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                
                // WHEN
                let viewController = storyBoard.instantiateViewControllerWithIdentifier("search") as! WeatherSearchViewController
                
                // THEN
                expect(viewController.tableView.tableHeaderView).toEventuallyNot(beNil())
                expect(viewController.tableView.tableHeaderView).toEventually(beAKindOf(UISearchBar))
            }
        }
        describe("searchBarSearchButtonClicked()") {
            it("should notify the event handler") {
                class MockEventHandler: WeatherSearchViewEventHandler {
                    var onBeforeSearchIsCalled = false
                    var onSearchForWeatherIsCalled = false
                    func onBeforeSearch() {
                        onBeforeSearchIsCalled = true
                    }
                    func onSearchForWeather(city: String) {
                        onSearchForWeatherIsCalled = true
                    }
                }
                // GIVEN
                let eventHandler = MockEventHandler()
                let viewController = WeatherSearchViewController()
                viewController.eventHandler = eventHandler
                let searchBar = viewController.tableView.tableHeaderView as! UISearchBar
                
                // WHEN
                searchBar.text = "London"
                viewController.searchBarSearchButtonClicked(searchBar)
                
                // THEN
                expect(eventHandler.onSearchForWeatherIsCalled).to(beTrue())
            }
        }
    }
}