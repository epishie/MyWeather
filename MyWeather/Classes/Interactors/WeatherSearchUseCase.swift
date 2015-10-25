//
//  WeatherSearchUseCase.swift
//  MyWeather
//
//  Created by Seph Iturralde on 25/10/2015.
//  Copyright © 2015 Epishie. All rights reserved.
//

import Foundation

class WeatherSearchUseCase {
    unowned let output: WeatherSearchUseCaseOutput
    unowned let weatherSearchService: WeatherSearchService
    
    init(output: WeatherSearchUseCaseOutput, weatherSearchService: WeatherSearchService) {
        self.output = output
        self.weatherSearchService = weatherSearchService
    }
    
    func searchForWeather(city: String) {
        weatherSearchService.searchForWeather(city) {
            [unowned output = self.output]
            (weather, error) in
            guard let weather = weather else {
                output.searchDidFail(error!)
                return
            }
            
            output.searchDidFoundWeather(weather)
        }
    }
}

protocol WeatherSearchUseCaseOutput: class {
    
    func searchDidFoundWeather(weather: Weather)
    func searchDidFail(error: WeatherSearchError)
}

enum WeatherSearchError {
    case NetworkError
    case SearchError
}