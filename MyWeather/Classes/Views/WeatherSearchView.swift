//
//  WeatherSearchView.swift
//  MyWeather
//
//  Created by Seph Iturralde on 25/10/2015.
//  Copyright © 2015 Epishie. All rights reserved.
//

import Foundation

protocol WeatherSearchView: class {
    
    func showErrorMessage(message: String)
    func showSearchHistory(history: [String])
}

protocol WeatherSearchViewEventHandler: class {
    
    func onBeforeSearch()
    func onSearchForWeather(city: String)
}