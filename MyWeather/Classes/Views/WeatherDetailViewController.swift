//
//  WeatherDetailViewController.swift
//  MyWeather
//
//  Created by Seph Iturralde on 26/10/2015.
//  Copyright © 2015 Epishie. All rights reserved.
//

import UIKit

class WeatherDetailViewController: UITableViewController {
    var eventHandler: WeatherDetailEventHandler!
    var weather: (String, NSData?, String, Int, String)?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView() // Work-around to hide separators on empty cells
        tableView.allowsSelection = false
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)

        eventHandler.onLoad()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = weather?.0
            cell.imageView?.image = UIImage(data: (weather?.1)!)
            cell.detailTextLabel?.text = ""
        case 1:
            cell.textLabel?.text = "Observation Time"
            cell.detailTextLabel?.text = weather?.2
        case 2:
            cell.textLabel?.text = "Humidity"
            let humidity = (weather?.3)!
            cell.detailTextLabel?.text = "\(humidity)%"
        case 3:
            cell.textLabel?.text = "Description"
            cell.detailTextLabel?.text = weather?.4
        default:
            break
        }

        return cell
    }
    
    func refresh(sender: AnyObject?) {
        eventHandler.onRefresh()
    }
}

extension WeatherDetailViewController: WeatherDetailView {
    
    func showWeather(weather: (String, NSData?, String, Int, String)) {
        self.weather = weather
        tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }
}