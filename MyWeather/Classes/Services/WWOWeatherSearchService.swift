//
//  WWOWeatherSearchService.swift
//  MyWeather
//
//  Created by Seph Iturralde on 25/10/2015.
//  Copyright © 2015 Epishie. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class WWOWeatherSearchService: WeatherSearchService {
    // http://api.worldweatheronline.com/free/v1/weather.ashx?key=vzkjnx2j5f88vyn5dhvvqkzc&q=London&fx=yes&format=json
    let apiHost = "http://api.worldweatheronline.com"
    let apiPath = "/free/v1/weather.ashx"
    let apiKey = "vzkjnx2j5f88vyn5dhvvqkzc"
    var lastWeather: Weather?
    
    func searchForWeather(city: String, completionHandler: (Weather?, WeatherSearchError?) -> Void) {
        var parameters = [String: String]()
        parameters["key"] = apiKey
        parameters["q"] = city
        parameters["fx"] = "yes"
        parameters["format"] = "json"
        Alamofire.request(.GET, apiHost + apiPath, parameters: parameters).responseJSON() {
            response in
            switch response.result {
            case .Success(let result):
                let json = JSON(result)
                let data = json["data"]
                guard data["error"] == nil else {
                    completionHandler(nil, WeatherSearchError.SearchError)
                    return
                }
                let city = data["request"][0]["query"].stringValue
                let iconUrl = data["current_condition"][0]["weatherIconUrl"][0]["value"].stringValue
                let icon = NSData(contentsOfURL: NSURL(string: iconUrl)!)
                let observationTime = data["current_condition"][0]["observation_time"].stringValue
                let humidity = data["current_condition"][0]["humidity"].intValue
                let description = data["current_condition"][0]["weatherDesc"][0]["value"].stringValue
                let weather = Weather(city: city, icon: icon, observationTime: observationTime, humidity: humidity, description: description)
                completionHandler(weather, nil)
                self.lastWeather = weather
            case .Failure:
                completionHandler(nil, WeatherSearchError.NetworkError)
            }
        }
    }
}