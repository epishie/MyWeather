//
//  WeatherDetailUseCase.swift
//  MyWeather
//
//  Created by Seph Iturralde on 26/10/2015.
//  Copyright © 2015 Epishie. All rights reserved.
//

import Foundation

class WeatherDetailUseCase {
    weak var output: WeatherDetailUseCaseOutput?
    unowned let weatherSearchService: WeatherSearchService
    
    init(weatherSearchService: WeatherSearchService) {
        self.weatherSearchService = weatherSearchService
    }
    
    func getAvailableWeatherDetail() {
        guard let weather = weatherSearchService.lastWeather else {
            output?.weatherDetailIsNotAvailable(WeatherSearchError.SearchError)
            return
        }
        output?.weatherDetailIsAvailale(weather)
    }
    
    func refresh() {
        weatherSearchService.searchForWeather(weatherSearchService.lastWeather!.city) {
            [unowned self = self]
            (weather, error) in
            guard let weather = weather else {
                self.output?.weatherDetailIsNotAvailable(error!)
                return
            }
            
            self.output?.weatherDetailIsAvailale(weather)
        }
    }
}

protocol WeatherDetailUseCaseOutput: class {
    
    func weatherDetailIsAvailale(weather: Weather)
    func weatherDetailIsNotAvailable(error: WeatherSearchError)
}
