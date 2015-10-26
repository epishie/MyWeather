//
//  WeatherSearchUseCase.swift
//  MyWeather
//
//  Created by Seph Iturralde on 25/10/2015.
//  Copyright © 2015 Epishie. All rights reserved.
//

import Foundation

class WeatherSearchUseCase {
    weak var output: WeatherSearchUseCaseOutput?
    unowned let weatherSearchService: WeatherSearchService
    unowned let userPreferenceService: UserPreferenceService
    
    init(weatherSearchService: WeatherSearchService, userPreferenceService: UserPreferenceService) {
        self.weatherSearchService = weatherSearchService
        self.userPreferenceService = userPreferenceService
    }
    
    func searchForWeather(city: String) {
        weatherSearchService.searchForWeather(city) {
            [unowned self = self]
            (weather, error) in
            guard let weather = weather else {
                self.output?.searchDidFail(error!)
                return
            }
            
            self.output?.searchDidFoundWeather(weather)
            self.userPreferenceService.addSearchHistory(city)
        }
    }
    
    func getSearchHistory() {
        let history = userPreferenceService.getSearchHistory()
        output?.searchDidFoundHistory(history)
    }
}

protocol WeatherSearchUseCaseOutput: class {
    
    func searchDidFoundWeather(weather: Weather)
    func searchDidFail(error: WeatherSearchError)
    func searchDidFoundHistory(history: [String])
}

enum WeatherSearchError {
    case NetworkError
    case SearchError
}