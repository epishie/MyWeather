//
//  WeatherDetailControllerSpec.swift
//  MyWeather
//
//  Created by Seph Iturralde on 26/10/2015.
//  Copyright © 2015 Epishie. All rights reserved.
//

import UIKit
import Quick
import Nimble
@testable import MyWeather

class WeatherDetailViewControllerSpec: QuickSpec {
    
    override func spec() {
        describe("viewDidLoad") {
            it("notifies the event handler") {
                // GIVEN
                class MockEventHandler: WeatherDetailEventHandler {
                    var onLoadIsCalled = false
                    var onRefreshIsCalled = false
                    
                    func onLoad() {
                        onLoadIsCalled = true
                    }
                    private func onRefresh() {
                        onRefreshIsCalled = true
                    }
                }
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let eventHandler = MockEventHandler()
                let viewController = storyBoard.instantiateViewControllerWithIdentifier("detail") as! WeatherDetailViewController
                viewController.eventHandler = eventHandler
                
                // WHEN
                viewController.viewDidLoad()
                
                // THEN
                expect(eventHandler.onLoadIsCalled).toEventually(beTrue())
            }
        }
        describe("showWeather()") {
            it("shows the weather details on a table view") {
                // GIVEN
                class MockTableView: UITableView {
                    var reloadDataIsCalled = false
                    override func reloadData() {
                        super.reloadData()
                        reloadDataIsCalled = true
                    }
                }
                let tableView = MockTableView()
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let viewController = storyBoard.instantiateViewControllerWithIdentifier("detail") as! WeatherDetailViewController
                viewController.tableView = tableView
                
                // WHEN
                viewController.showWeather(("London", nil, "1:00 AM", 71, "Sunny"))
                
                // THEN
                expect(tableView.reloadDataIsCalled).to(beTrue())
            }
        }
    }
}