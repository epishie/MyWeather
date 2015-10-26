//
//  WeatherSearchUseCaseSpec.swift
//  MyWeather
//
//  Created by Seph Iturralde on 25/10/2015.
//  Copyright © 2015 Epishie. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import MyWeather

class WeatherSearchUseCaseSpec: QuickSpec {
    
    override func spec() {
        class MockOutput: WeatherSearchUseCaseOutput {
            var searchDidFoundWeatherIsCalled = false
            var searchDidFailIsCalled = false
            var searchDidFoundHistoryIsCalled = false
            var weather: Weather?
            var error: WeatherSearchError?
            var history: [String]?
            
            func searchDidFoundWeather(weather: Weather) {
                searchDidFoundWeatherIsCalled = true
                self.weather = weather
            }
            
            func searchDidFail(error: WeatherSearchError) {
                searchDidFailIsCalled = true
                self.error = error
            }
            
            func searchDidFoundHistory(history: [String]) {
                searchDidFoundHistoryIsCalled = true
                self.history = history
            }
        }
        describe("searchForWeather") {
            class MockUserPreferenceService: UserPreferenceService {
                var search: String?
                var addSearchHistoryIsCalled = false
                
                func addSearchHistory(search: String) {
                    addSearchHistoryIsCalled = true
                    self.search = search
                }
                
                private func getSearchHistory() -> [String] {
                    return [String]()
                }
            }
            it("sends an error output on failure") {
                // GIVEN
                class MockService: WeatherSearchService {
                    var lastWeather: Weather?
                    var searchForWeatherIsCalled = false
                    var city: String?
                    var completionHandler: ((Weather?, WeatherSearchError?) -> Void)?
                    
                    func searchForWeather(city: String, completionHandler: (Weather?, WeatherSearchError?) -> Void) {
                        completionHandler(nil, WeatherSearchError.SearchError)
                        searchForWeatherIsCalled = true
                        self.city = city
                        self.completionHandler = completionHandler
                    }
                }
                let output = MockOutput()
                let service = MockService()
                let useCase = WeatherSearchUseCase(weatherSearchService: service, userPreferenceService: MockUserPreferenceService())
                useCase.output = output
                
                // WHEN
                useCase.searchForWeather("Error City")
                
                // THEN
                expect(service.searchForWeatherIsCalled).to(beTrue())
                expect(service.city).to(equal("Error City"))
                expect(service.completionHandler).toNot(beNil())
                expect(output.searchDidFailIsCalled).to(beTrue())
                expect(output.error).to(equal(WeatherSearchError.SearchError))
            }
            it("sends a weather output on success and adds the search to history") {
                class MockService: WeatherSearchService {
                    var lastWeather: Weather?
                    var searchForWeatherIsCalled = false
                    var city: String?
                    var completionHandler: ((Weather?, WeatherSearchError?) -> Void)?
                    
                    func searchForWeather(city: String, completionHandler: (Weather?, WeatherSearchError?) -> Void) {
                        let weather = Weather(city: city, icon: nil, observationTime: "1:00 AM", humidity: 71, description: "Sunny")
                        completionHandler(weather, nil)
                        searchForWeatherIsCalled = true
                        self.city = city
                        self.completionHandler = completionHandler
                    }
                }
                let output = MockOutput()
                let service = MockService()
                let userPreferenceService = MockUserPreferenceService()
                let useCase = WeatherSearchUseCase(weatherSearchService: service, userPreferenceService: userPreferenceService)
                useCase.output = output
                
                // WHEN
                useCase.searchForWeather("London")
                
                // THEN
                expect(service.searchForWeatherIsCalled).to(beTrue())
                expect(service.city).to(equal("London"))
                expect(service.completionHandler).toNot(beNil())
                expect(output.searchDidFoundWeatherIsCalled).to(beTrue())
                expect(output.weather).to(equal(Weather(city: "London", icon: nil, observationTime: "1:00 AM", humidity: 71, description: "Sunny")))
                expect(userPreferenceService.addSearchHistoryIsCalled).to(beTrue())
                expect(userPreferenceService.search).to(equal("London"))
            }
        }
        describe("getSearchHistory()") {
            class MockUserPreferenceService: UserPreferenceService {
                var history = [String]()
                var getSearchHistoryIsCalled = false
                
                func addSearchHistory(search: String) {
                }
                
                private func getSearchHistory() -> [String] {
                    getSearchHistoryIsCalled = true
                    return history
                }
            }
            class MockService: WeatherSearchService {
                var lastWeather: Weather?
                func searchForWeather(city: String, completionHandler: (Weather?, WeatherSearchError?) -> Void) {
                }
            }
            it("send a history output on success") {
                // GIVEN
                let history = ["London", "Madrid", "Paris"]
                let output = MockOutput()
                let service = MockService()
                let userPreferenceService = MockUserPreferenceService()
                userPreferenceService.history = history
                let useCase = WeatherSearchUseCase(weatherSearchService: service, userPreferenceService: userPreferenceService)
                useCase.output = output
                
                // WHEN
                useCase.getSearchHistory()
                
                // THEN
                expect(output.searchDidFoundHistoryIsCalled).to(beTrue())
                expect(output.history).toNot(beNil())
                expect(output.history).to(equal(history))
            }
        }
    }
}