//
//  WeatherDetailView.swift
//  MyWeather
//
//  Created by Seph Iturralde on 26/10/2015.
//  Copyright © 2015 Epishie. All rights reserved.
//

import Foundation

protocol WeatherDetailView: class {
    
    func showWeather(weather: (String, NSData?, String, Int, String))
    func showErrorMessage(message: String)
}

protocol WeatherDetailEventHandler: class {
    
    func onLoad()
    func onRefresh()
}