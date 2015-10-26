//
//  WeatherSearchViewController.swift
//  MyWeather
//
//  Created by Seph Iturralde on 26/10/2015.
//  Copyright © 2015 Epishie. All rights reserved.
//

import UIKit

class WeatherSearchViewController: UITableViewController {
    var eventHandler: WeatherSearchViewEventHandler!
    var searchController: UISearchController?
    var history: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "MyWeather"
        searchController = UISearchController(searchResultsController: nil)
        searchController?.dimsBackgroundDuringPresentation = false
        searchController?.delegate = self
        searchController?.searchBar.sizeToFit()
        searchController?.searchBar.delegate = self
        tableView.tableHeaderView = searchController?.searchBar
        tableView.tableFooterView = UIView() // Work-around to hide separators on empty cells
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if searchController == nil || !searchController!.active {
            return 0
        }
        if history == nil {
            return 0
        }
        
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController == nil || !searchController!.active {
            return 0
        }
        if history == nil {
            return 0
        }
        
        return history!.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        cell.textLabel?.text = history![indexPath.row]
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Perform search using history
        let search = history?[indexPath.row]
        eventHandler.onSearchForWeather(search!)
        searchController?.active = false
    }
}

extension WeatherSearchViewController: WeatherSearchView {
    
    func showErrorMessage(message: String) {
        let alertController = UIAlertController(title: NSLocalizedString("MyWeather", comment: ""), message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("Dismiss", comment: ""), style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func showSearchHistory(history: [String]) {
        self.history = history
        tableView.reloadData()
    }
}

extension WeatherSearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        // Perform search
        eventHandler.onSearchForWeather(searchBar.text!)
        searchController?.active = false
    }
}

extension WeatherSearchViewController: UISearchControllerDelegate {
    
    func didPresentSearchController(searchController: UISearchController) {
        eventHandler.onBeforeSearch()
    }
    
    func didDismissSearchController(searchController: UISearchController) {
        tableView.reloadData()
    }
}