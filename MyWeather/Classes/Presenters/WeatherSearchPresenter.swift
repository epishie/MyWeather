//
//  WeatherSearchPresenter.swift
//  MyWeather
//
//  Created by Seph Iturralde on 25/10/2015.
//  Copyright © 2015 Epishie. All rights reserved.
//

import Foundation

class WeatherSearchPresenter: WeatherSearchUseCaseOutput, WeatherSearchViewEventHandler {
    let useCase: WeatherSearchUseCase
    weak var view: WeatherSearchView?
    weak var wireframe: WeatherSearchWireframe?
    
    init(useCase: WeatherSearchUseCase) {
        self.useCase = useCase
    }
    
    func searchDidFoundWeather(weather: Weather) {
        wireframe?.navigateToDetail()
    }
    
    func searchDidFail(error: WeatherSearchError) {
        switch error {
        case .SearchError:
            view?.showErrorMessage(NSLocalizedString("Search Error Message", comment: ""))
        case .NetworkError:
            view?.showErrorMessage(NSLocalizedString("Network Error Message", comment: ""))
        }
    }
    
    func searchDidFoundHistory(history: [String]) {
        view?.showSearchHistory(history)
    }
    
    func onSearchForWeather(city: String) {
        useCase.searchForWeather(city)
    }
    
    func onBeforeSearch() {
        useCase.getSearchHistory()
    }
}