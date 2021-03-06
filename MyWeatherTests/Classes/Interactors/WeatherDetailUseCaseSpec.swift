//
//  WeatherDetailUseCaseSpec.swift
//  MyWeather
//
//  Created by Seph Iturralde on 26/10/2015.
//  Copyright © 2015 Epishie. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import MyWeather

class WeatheDetailUseCaseSpec: QuickSpec {
    
    override func spec() {
        class MockOutput: WeatherDetailUseCaseOutput {
            var weather: Weather?
            var weatherDetailIsAvaiableIsCalled = false
            var error: WeatherSearchError?
            var weatherDetailIsNotAvailableIsCalled = false
            
            func weatherDetailIsAvailale(weather: Weather) {
                weatherDetailIsAvaiableIsCalled = true
                self.weather = weather
            }
            
            func weatherDetailIsNotAvailable(error: WeatherSearchError) {
                weatherDetailIsNotAvailableIsCalled = true
                self.error = error
            }
        }
        describe("getAvaiableWeatherDetail()") {
            it("should return a weather output on success") {
                // GIVEN
                class MockService: WeatherSearchService {
                    var lastWeather: Weather?
                    
                    init() {
                        lastWeather = Weather(city: "London", icon: nil, observationTime: "1:00 AM", humidity: 71, description: "Sunny")
                    }
                    
                    func searchForWeather(city: String, completionHandler: (Weather?, WeatherSearchError?) -> Void) {
                    }
                }
                let output = MockOutput()
                let service = MockService()
                let useCase = WeatherDetailUseCase(weatherSearchService: service)
                useCase.output = output
                
                // WHEN
                useCase.getAvailableWeatherDetail()
                
                // THEN
                expect(output.weatherDetailIsAvaiableIsCalled).to(beTrue())
                expect(output.weather).to(equal(service.lastWeather))
            }
            it("does nothing on failure") {
                // GIVEN
                class MockService: WeatherSearchService {
                    var lastWeather: Weather?
                    
                    func searchForWeather(city: String, completionHandler: (Weather?, WeatherSearchError?) -> Void) {
                        completionHandler(nil, WeatherSearchError.SearchError)
                    }
                }
                let output = MockOutput()
                let service = MockService()
                let useCase = WeatherDetailUseCase(weatherSearchService: service)
                useCase.output = output
                
                // WHEN
                useCase.getAvailableWeatherDetail()
                
                // THEN
                expect(output.weatherDetailIsAvaiableIsCalled).to(beFalse())
            }
        }
        describe("refresh()") {
            it("returns a weather output on success") {
                // GIVEN
                class MockService: WeatherSearchService {
                    var lastWeather: Weather?
                    var searchForWeatherIsCalled = false
                    var newWeather: Weather?
                    
                    init() {
                        lastWeather = Weather(city: "London", icon: nil, observationTime: "1:00 AM", humidity: 71, description: "Sunny")
                    }
                    
                    func searchForWeather(city: String, completionHandler: (Weather?, WeatherSearchError?) -> Void) {
                        newWeather = Weather(city: "London", icon: nil, observationTime: "2:00 AM", humidity: 71, description: "Sunny")
                        completionHandler(newWeather, nil)
                        searchForWeatherIsCalled = true
                    }
                }
                let output = MockOutput()
                let service = MockService()
                let useCase = WeatherDetailUseCase(weatherSearchService: service)
                useCase.output = output
                
                // WHEN
                useCase.refresh()
                
                // THEN
                expect(output.weatherDetailIsAvaiableIsCalled).to(beTrue())
                expect(output.weather).to(equal(service.newWeather))
            }
            it("returns an error output on failure") {
                // GIVEN
                class MockService: WeatherSearchService {
                    var lastWeather: Weather?
                    
                    init() {
                        lastWeather = Weather(city: "London", icon: nil, observationTime: "1:00 AM", humidity: 71, description: "Sunny")
                    }
                    
                    func searchForWeather(city: String, completionHandler: (Weather?, WeatherSearchError?) -> Void) {
                        completionHandler(nil, WeatherSearchError.SearchError)
                    }
                }
                let output = MockOutput()
                let service = MockService()
                let useCase = WeatherDetailUseCase(weatherSearchService: service)
                useCase.output = output
                
                // WHEN
                useCase.refresh()
                
                // THEN
                expect(output.weatherDetailIsNotAvailableIsCalled).to(beTrue())
                expect(output.error).to(equal(WeatherSearchError.SearchError))
            }
        }
    }
}