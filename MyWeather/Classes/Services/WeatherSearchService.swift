//
//  WeatherSearchService.swift
//  MyWeather
//
//  Created by Seph Iturralde on 25/10/2015.
//  Copyright © 2015 Epishie. All rights reserved.
//

import Foundation

protocol WeatherSearchService: class {
    
    func searchForWeather(city: String, completionHandler: (Weather?, WeatherSearchError?) -> Void)
}