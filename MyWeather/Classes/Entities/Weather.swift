//
//  Weather.swift
//  MyWeather
//
//  Created by Seph Iturralde on 25/10/2015.
//  Copyright © 2015 Epishie. All rights reserved.
//

import Foundation

struct Weather {
    var city: String
    var icon: NSData?
    var observationTime: String
    var humidity: Int
    var description: String
}

extension Weather: Equatable {}

func ==(lhs: Weather, rhs: Weather) -> Bool {
    return lhs.city == rhs.city &&
        lhs.icon == rhs.icon &&
        lhs.observationTime == rhs.observationTime &&
        lhs.humidity == rhs.humidity &&
        lhs.description == rhs.description
}