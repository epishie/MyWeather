//
//  WeatherDetailPresenter.swift
//  MyWeather
//
//  Created by Seph Iturralde on 26/10/2015.
//  Copyright © 2015 Epishie. All rights reserved.
//

import Foundation

class WeatherDetailPresenter: WeatherDetailUseCaseOutput, WeatherDetailEventHandler {
    let useCase: WeatherDetailUseCase
    weak var view: WeatherDetailView?
    
    init(useCase: WeatherDetailUseCase) {
        self.useCase = useCase
    }
    
    func onLoad() {
        useCase.getAvailableWeatherDetail()
    }
    
    func onRefresh() {
        useCase.refresh()
    }
    
    func weatherDetailIsAvailale(weather: Weather) {
        view?.showWeather((weather.city, weather.icon, weather.observationTime, weather.humidity, weather.description))
    }
    
    func weatherDetailIsNotAvailable(error: WeatherSearchError) {
        switch error {
        case .SearchError:
            view?.showErrorMessage(NSLocalizedString("Search Error Message", comment: ""))
        case .NetworkError:
            view?.showErrorMessage(NSLocalizedString("Network Error Message", comment: ""))
        }
    }
}