//
//  Wireframe.swift
//  MyWeather
//
//  Created by Seph Iturralde on 25/10/2015.
//  Copyright © 2015 Epishie. All rights reserved.
//

import UIKit
import Swinject

class RootWireframe {
    let window: UIWindow
    let container: Container
    let storyboard: SwinjectStoryboard
    var navigationViewController: UINavigationController?
    var searchWireframe: WeatherSearchWireframe?
    
    init(window: UIWindow) {
        self.window = window
        container = Container()
        storyboard = SwinjectStoryboard.create(name: "Main", bundle: nil, container: container)
        navigationViewController = storyboard.instantiateViewControllerWithIdentifier("root") as? UINavigationController
        window.rootViewController = navigationViewController
        
        setupDependencies()
    }
    
    private func setupDependencies() {
        let storyboard = self.storyboard
        // Weather Search Wireframe
        container.register(WeatherSearchWireframe.self) {
            container in
            let wireframe = WeatherSearchWireframe()
            wireframe.rootWireframe = self
            wireframe.viewController = container.resolve(WeatherSearchViewController.self)
            return wireframe
        }
        
        // Weather Search View Controller
        container.register(WeatherSearchViewController.self) {
            container in
            let viewController = storyboard.instantiateViewControllerWithIdentifier("search") as! WeatherSearchViewController
            viewController.eventHandler = container.resolve(WeatherSearchPresenter.self)
            return viewController
        }
        
        // Weather Search Presenter
        container.register(WeatherSearchPresenter.self) {
            container in
            let useCase = container.resolve(WeatherSearchUseCase.self)!
            return WeatherSearchPresenter(useCase: useCase)
            }.initCompleted {
                container, presenter in
                presenter.view = container.resolve(WeatherSearchViewController.self)
                presenter.wireframe = container.resolve(WeatherSearchWireframe.self)
        }
        
        // Weather Search Use Case
        container.register(WeatherSearchUseCase.self) {
            container in
            let searchService = container.resolve(WeatherSearchService.self)!
            let userPreferenceService = container.resolve(UserPreferenceService.self)!
            return WeatherSearchUseCase(weatherSearchService: searchService, userPreferenceService: userPreferenceService)
            }.initCompleted{
                container, useCase in
                useCase.output = container.resolve(WeatherSearchPresenter.self)
        }
        
        // Weather Search Service
        container.register(WeatherSearchService.self) {
            _ in
            WWOWeatherSearchService()
        }.inObjectScope(.Container)
        
        // User Preference Service
        container.register(UserPreferenceService.self) {
            _ in
            DefaultsUserPreferenceService()
        }.inObjectScope(.Container)
        
        // Weather Detail Wireframe
        container.register(WeatherDetailWireframe.self) {
            container in
            let wireframe = WeatherDetailWireframe()
            wireframe.rootWireframe = self
            wireframe.viewController = container.resolve(WeatherDetailViewController.self)
            return wireframe
        }
        
        // Weather Detail View Controller
        container.register(WeatherDetailViewController.self) {
            container in
            let viewController = storyboard.instantiateViewControllerWithIdentifier("detail") as! WeatherDetailViewController
            viewController.eventHandler = container.resolve(WeatherDetailPresenter.self)
            return viewController
        }
        
        // Weather Detail Presenter
        container.register(WeatherDetailPresenter.self) {
            container in
            let useCase = container.resolve(WeatherDetailUseCase.self)!
            return WeatherDetailPresenter(useCase: useCase)
            }.initCompleted {
                container, presenter in
                presenter.view = container.resolve(WeatherDetailViewController.self)
        }
        
        // Weather Detail Use Case
        container.register(WeatherDetailUseCase.self) {
            container in
            let service = container.resolve(WeatherSearchService.self)!
            return WeatherDetailUseCase(weatherSearchService: service)
            }.initCompleted {
                container, useCase in
                useCase.output = container.resolve(WeatherDetailPresenter.self)
        }
    }
    
    func setupRootViewController() {
        searchWireframe = container.resolve(WeatherSearchWireframe.self)
        searchWireframe?.presentViewController()
        
        window.makeKeyAndVisible()
    }
}