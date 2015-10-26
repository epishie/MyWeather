//
//  WWOWeatherSearchServiceSpec.swift
//  MyWeather
//
//  Created by Seph Iturralde on 25/10/2015.
//  Copyright © 2015 Epishie. All rights reserved.
//

import Foundation
import Quick
import Nimble
import OHHTTPStubs
@testable import MyWeather

class WWOWeatherSearchServiceSpec: QuickSpec {
    
    override func spec() {
        describe("searchForWeather()") {
            afterEach {
                OHHTTPStubs.removeAllStubs()
            }
            it("should call World Weather Online with correct parameters") {
                // GIVEN
                var requestURL: NSURLComponents?
                OHHTTPStubs.stubRequestsPassingTest({ request in
                    if request.URL?.host == "api.worldweatheronline.com" {
                        requestURL = NSURLComponents(URL: (request.URL)!, resolvingAgainstBaseURL: true)
                        return true
                    }
                    return false
                    }, withStubResponse: { _ in
                        OHHTTPStubsResponse()
                })
                let service = WWOWeatherSearchService()
                
                // WHEN
                service.searchForWeather("London") {
                    (weather, error) in
                    
                }
                
                // THEN
                expect(requestURL).toEventuallyNot(beNil())
                expect(requestURL?.path).toEventually(equal("/free/v1/weather.ashx"))
                expect(requestURL?.queryItems?.contains(NSURLQueryItem(name: "key", value: "vzkjnx2j5f88vyn5dhvvqkzc"))).toEventually(beTrue())
                expect(requestURL?.queryItems?.contains(NSURLQueryItem(name: "q", value: "London"))).toEventually(beTrue())
                expect(requestURL?.queryItems?.contains(NSURLQueryItem(name: "format", value: "json"))).toEventually(beTrue())
                expect(requestURL?.queryItems?.contains(NSURLQueryItem(name: "fx", value: "yes"))).toEventually(beTrue())
            }
            it("should call completion handler with weather on success") {
                // GIVEN
                OHHTTPStubs.stubRequestsPassingTest({ request in
                    request.URL?.host == "api.worldweatheronline.com"
                    }, withStubResponse: { _ in
                        OHHTTPStubsResponse(fileAtPath: OHPathForFile("london.json", self.dynamicType)!, statusCode: 200, headers: ["Content-Type": "application/json"])
                })
                let service = WWOWeatherSearchService()
                
                // WHEN
                var currentWeather: Weather?
                var searchError: WeatherSearchError?
                service.searchForWeather("London") {
                    (weather, error) in
                    currentWeather = weather
                    searchError = error
                }
                
                // THEN
                let icon = NSData(contentsOfURL: NSURL(string: "http://cdn.worldweatheronline.net/images/wsymbols01_png_64/wsymbol_0002_sunny_intervals.png")!)
                expect(currentWeather).toEventually(equal(Weather(city: "London, United Kingdom", icon: icon, observationTime: "07:00 AM", humidity: 71, description: "Partly Cloudy")))
                expect(searchError).toEventually(beNil())
                expect(service.lastWeather).toEventually(equal(currentWeather))
            }
            it("should call completion handler with error if city is not found") {
                // GIVEN
                OHHTTPStubs.stubRequestsPassingTest({ request in
                    request.URL?.host == "api.worldweatheronline.com"
                    }, withStubResponse: { _ in
                        OHHTTPStubsResponse(fileAtPath: OHPathForFile("notFound.json", self.dynamicType)!, statusCode: 200, headers: ["Content-Type": "application/json"])
                })
                let service = WWOWeatherSearchService()
                
                // WHEN
                var currentWeather: Weather?
                var searchError: WeatherSearchError?
                service.searchForWeather("error_not_found") {
                    (weather, error) in
                    currentWeather = weather
                    searchError = error
                }
                
                // THEN
                expect(currentWeather).toEventually(beNil())
                expect(searchError).toEventually(equal(WeatherSearchError.SearchError))
                expect(service.lastWeather).toEventually(beNil())
            }
            it("should call completion handler with error network failure") {
                // GIVEN
                OHHTTPStubs.stubRequestsPassingTest({ request in
                    request.URL?.host == "api.worldweatheronline.com"
                    }, withStubResponse: { _ in
                        let notConnectedError = NSError(domain:NSURLErrorDomain, code:Int(CFNetworkErrors.CFURLErrorBadServerResponse.rawValue), userInfo:nil)
                        return OHHTTPStubsResponse(error:notConnectedError)
                })
                let service = WWOWeatherSearchService()
                
                // WHEN
                var currentWeather: Weather?
                var searchError: WeatherSearchError?
                service.searchForWeather("London") {
                    (weather, error) in
                    currentWeather = weather
                    searchError = error
                }
                
                // THEN
                expect(currentWeather).toEventually(beNil())
                expect(searchError).toEventually(equal(WeatherSearchError.NetworkError))
                expect(service.lastWeather).toEventually(beNil())
            }
        }
    }
}