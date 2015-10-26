//
//  WeatherSearchWireframe.swift
//  MyWeather
//
//  Created by Seph Iturralde on 26/10/2015.
//  Copyright © 2015 Epishie. All rights reserved.
//

import Foundation

class WeatherSearchWireframe {
    var rootWireframe: RootWireframe?
    var viewController: WeatherSearchViewController?
    var detailWireframe: WeatherDetailWireframe?
    
    func presentViewController() {
        rootWireframe?.navigationViewController?.viewControllers = [viewController!]
    }
    
    func navigateToDetail() {
        detailWireframe = rootWireframe?.container.resolve(WeatherDetailWireframe.self)
        rootWireframe?.navigationViewController?.pushViewController((detailWireframe?.viewController)!, animated: true)
    }
}