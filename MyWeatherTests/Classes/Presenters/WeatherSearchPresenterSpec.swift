//
//  WeatherSearchPresenterSpec.swift
//  MyWeather
//
//  Created by Seph Iturralde on 25/10/2015.
//  Copyright © 2015 Epishie. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import MyWeather

class WeatherSearchPresenterSpec: QuickSpec {
    
    override func spec() {
        class MockUseCase: WeatherSearchUseCase {
            var searchForWeatherIsCalled = false
            var city: String?
            var getSearchHistoryIsCalled = false
            
            init() {
                super.init(weatherSearchService: WWOWeatherSearchService(), userPreferenceService: DefaultsUserPreferenceService())
            }
            
            override func searchForWeather(city: String) {
                searchForWeatherIsCalled = true
                self.city = city
            }
            
            override func getSearchHistory() {
                getSearchHistoryIsCalled = true
            }
        }
        class MockView: WeatherSearchView {
            var showErrorMessageIsCalled = false
            var message: String?
            var showSearchHistoryIsCalled = false
            var history: [String]?
            
            func showErrorMessage(message: String) {
                showErrorMessageIsCalled = true
                self.message = message
            }
            
            private func showSearchHistory(history: [String]) {
                showSearchHistoryIsCalled = true
                self.history = history
            }
        }
        
        class MockWireframe: WeatherSearchWireframe {
            var navigateToDetailIsCalled = false
            
            override func navigateToDetail() {
                navigateToDetailIsCalled = true
            }
        }
        describe("searchDidFail()") {
            it("should tell the view to show the correct error message on search error") {
                // GIVEN
                let view = MockView()
                let presenter = WeatherSearchPresenter(useCase: MockUseCase())
                presenter.view = view
                
                // WHEN
                presenter.searchDidFail(WeatherSearchError.SearchError)
                
                // THEN
                expect(view.showErrorMessageIsCalled).to(beTrue())
                expect(view.message).to(equal(NSLocalizedString("Search Error Message", comment: "")))
            }
            it("should tell the view to show the correct error message on network error") {
                // GIVEN
                let view = MockView()
                let presenter = WeatherSearchPresenter(useCase: MockUseCase())
                presenter.view = view
                
                // WHEN
                presenter.searchDidFail(WeatherSearchError.NetworkError)
                
                // THEN
                expect(view.showErrorMessageIsCalled).to(beTrue())
                expect(view.message).to(equal(NSLocalizedString("Network Error Message", comment: "")))
            }
        }
        describe("searchDidFindWeather()") {
            it("should tell the wireframe to navigato to detail view") {
                // GIVEN
                let wireframe = MockWireframe()
                let presenter = WeatherSearchPresenter(useCase: MockUseCase())
                presenter.wireframe = wireframe
                let weather = Weather(city: "London", icon: nil, observationTime: "1:00 AM", humidity: 72, description: "Cloudy")
                
                // WHEN
                presenter.searchDidFoundWeather(weather)
                
                // THEN
                expect(wireframe.navigateToDetailIsCalled).to(beTrue())
            }
        }
        describe("searchDidFoundHistory()") {
            it ("should tell the view to display the history") {
                // GIVEN
                let view = MockView()
                let presenter = WeatherSearchPresenter(useCase: MockUseCase())
                presenter.view = view
                let history = ["London", "Madrid", "Paris"]
                
                // WHEN
                presenter.searchDidFoundHistory(history)
                
                // THEN
                expect(view.showSearchHistoryIsCalled).to(beTrue())
                expect(view.history).to(equal(history))
            }
        }
        describe("onLoad()") {
            it("exectutes WeatherSearchUseCase - getSearhHistory()") {
                // GIVEN
                let useCase = MockUseCase()
                let presenter = WeatherSearchPresenter(useCase: useCase)
                
                // WHEN
                presenter.onBeforeSearch()
                
                // THEN
                expect(useCase.getSearchHistoryIsCalled).to(beTrue())
            }
        }
        describe("onSearchForWeather()") {
            it("executes WeatherSearchUseCase") {
                // GIVEN
                let useCase = MockUseCase()
                let presenter = WeatherSearchPresenter(useCase: useCase)
                
                // WHEN
                presenter.onSearchForWeather("London")
                
                // THEN
                expect(useCase.searchForWeatherIsCalled).to(beTrue())
            }
        }
    }
}