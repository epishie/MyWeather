//
//  UserPreferenceService.swift
//  MyWeather
//
//  Created by Seph Iturralde on 26/10/2015.
//  Copyright © 2015 Epishie. All rights reserved.
//

import Foundation

protocol UserPreferenceService: class {
    
    func addSearchHistory(search: String)
    func getSearchHistory() -> [String]
}