//
//  WeatherDetailPresenterSpec.swift
//  MyWeather
//
//  Created by Seph Iturralde on 26/10/2015.
//  Copyright © 2015 Epishie. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import MyWeather

class WeatherDetailPresenterSpec: QuickSpec {
    
    override func spec() {
        class MockView: WeatherDetailView {
            var weather: (String, NSData?, String, Int, String)?
            var showWeatherIsCalled = false
            var message: String!
            var showErrorMessageIsCalled = false
            
            func showWeather(weather: (String, NSData?, String, Int, String)) {
                showWeatherIsCalled = true
                self.weather = weather
            }
            
            func showErrorMessage(message: String) {
                showErrorMessageIsCalled = true
                self.message = message
            }
        }
        class MockUseCase: WeatherDetailUseCase {
            var getAvailableWeatherIsCalled = false
            var refreshIsCalled = false
            
            init() {
                super.init(weatherSearchService: WWOWeatherSearchService())
            }
            
            override func getAvailableWeatherDetail() {
                getAvailableWeatherIsCalled = true
            }
            override func refresh() {
                refreshIsCalled = true
            }
        }
        describe("onLoad()") {
            it("executes WeatherDetailUseCase") {
                // GIVEN
                let useCase = MockUseCase()
                let presenter = WeatherDetailPresenter(useCase: useCase)
                
                // WHEN
                presenter.onLoad()
                
                // THEN
                expect(useCase.getAvailableWeatherIsCalled).to(beTrue())
            }
        }
        describe("") {
            it("executes WeatherDetailUseCase - refresh") {
                // GIVEN
                let useCase = MockUseCase()
                let presenter = WeatherDetailPresenter(useCase: useCase)
                
                // WHEN
                presenter.onRefresh()
                
                // THEN
                expect(useCase.refreshIsCalled).to(beTrue())
            }
        }
        describe("weatherDetailIsAvailable()") {
            it("tells the view to show the weather") {
                // GIVEN
                let view = MockView()
                let presenter = WeatherDetailPresenter(useCase: MockUseCase())
                presenter.view = view
                let weather = Weather(city: "London", icon: nil, observationTime: "1:00 AM", humidity: 72, description: "Cloudy")
                
                // WHEN
                presenter.weatherDetailIsAvailale(weather)
                
                // THEN
                expect(view.showWeatherIsCalled).to(beTrue())
                expect(view.weather?.0).to(equal(weather.city))
                expect(view.weather?.1).to(beNil())
                expect(view.weather?.2).to(equal(weather.observationTime))
                expect(view.weather?.3).to(equal(weather.humidity))
                expect(view.weather?.4).to(equal(weather.description))
            }
        }
        describe("weatherDetailIsAvailable()") {
            it("tells the view to show the error message on Network error") {
                // GIVEN
                let view = MockView()
                let presenter = WeatherDetailPresenter(useCase: MockUseCase())
                presenter.view = view
                
                // WHEN
                presenter.weatherDetailIsNotAvailable(WeatherSearchError.NetworkError)
                
                // THEN
                expect(view.showErrorMessageIsCalled).to(beTrue())
                expect(view.message).to(equal(NSLocalizedString("Network Error Message", comment: "")))
            }
            it("tells the view to show the error message on Search error") {
                // GIVEN
                let view = MockView()
                let presenter = WeatherDetailPresenter(useCase: MockUseCase())
                presenter.view = view
                
                // WHEN
                presenter.weatherDetailIsNotAvailable(WeatherSearchError.SearchError)
                
                // THEN
                expect(view.showErrorMessageIsCalled).to(beTrue())
                expect(view.message).to(equal(NSLocalizedString("Search Error Message", comment: "")))
            }
        }
    }
}