//
//  DefaultsUserPreferenceService.swift
//  MyWeather
//
//  Created by Seph Iturralde on 26/10/2015.
//  Copyright © 2015 Epishie. All rights reserved.
//

import Foundation

class DefaultsUserPreferenceService: UserPreferenceService {
    let key = "history"
    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    func addSearchHistory(search: String) {
        var history = userDefaults.arrayForKey(key) as? [String]
        if history == nil {
            history = [search]
        } else {
            guard history?.contains(search) == false else {
                return
            }
            if (history?.count == 10) {
                history?.removeFirst()
            }
            history?.append(search)
        }
        userDefaults.setValue(history, forKey: key)
    }
    
    func getSearchHistory() -> [String] {
        guard let history = userDefaults.arrayForKey(key) else {
            return []
        }
        return history as! [String]
    }
}