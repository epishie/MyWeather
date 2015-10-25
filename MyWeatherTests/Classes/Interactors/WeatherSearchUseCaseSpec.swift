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
            var weather: Weather?
            var error: WeatherSearchError?
            
            func searchDidFoundWeather(weather: Weather) {
                searchDidFoundWeatherIsCalled = true
                self.weather = weather
            }
            
            func searchDidFail(error: WeatherSearchError) {
                searchDidFailIsCalled = true
                self.error = error
            }
        }
        describe("searchForWeather") {
            it("should send an error output on failure") {
                // GIVEN
                class MockService: WeatherSearchService {
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
                let useCase = WeatherSearchUseCase(output: output, weatherSearchService: service)
                
                // WHEN
                useCase.searchForWeather("Error City")
                
                // THEN
                expect(service.searchForWeatherIsCalled).to(beTrue())
                expect(service.city).to(equal("Error City"))
                expect(service.completionHandler).toNot(beNil())
                expect(output.searchDidFailIsCalled).to(beTrue())
                expect(output.error).to(equal(WeatherSearchError.SearchError))
            }
            it("should send a weather output on success") {
                class MockService: WeatherSearchService {
                    var searchForWeatherIsCalled = false
                    var city: String?
                    var completionHandler: ((Weather?, WeatherSearchError?) -> Void)?
                    
                    func searchForWeather(city: String, completionHandler: (Weather?, WeatherSearchError?) -> Void) {
                        let weather = Weather(city: city)
                        completionHandler(weather, nil)
                        searchForWeatherIsCalled = true
                        self.city = city
                        self.completionHandler = completionHandler
                    }
                }
                let output = MockOutput()
                let service = MockService()
                let useCase = WeatherSearchUseCase(output: output, weatherSearchService: service)
                
                // WHEN
                useCase.searchForWeather("London")
                
                // THEN
                expect(service.searchForWeatherIsCalled).to(beTrue())
                expect(service.city).to(equal("London"))
                expect(service.completionHandler).toNot(beNil())
                expect(output.searchDidFoundWeatherIsCalled).to(beTrue())
                expect(output.weather).to(equal(Weather(city: "London")))
            }
        }
    }
}