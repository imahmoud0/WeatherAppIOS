//
//  LocationTableView.swift
//  WeatherAppiOS
//
//  Created by Mahmoud Ibrahmi on 14/08/2020.
//  Copyright © 2020 brahmi. All rights reserved.
//

import UIKit
import MapKit

class LocationTableView: UITableViewController {

     var handleLocationSearchDelegate: HandleLocationSearch?
     var matchingItems: [MKMapItem] = []

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchingItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        guard matchingItems.count > indexPath.row  else { return cell }
        let selectedItem = matchingItems[indexPath.row].placemark
        cell.textLabel?.text = selectedItem.name
        var cityName = ""
        if let city = selectedItem.locality {
            cityName = "\(city),"
        }
        let address = "\(cityName) \(selectedItem.subLocality ?? ""), \(selectedItem.country ?? "")"
        cell.detailTextLabel?.text = address

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard matchingItems.count > indexPath.row else { return }
        let selectedItem = matchingItems[indexPath.row].placemark
        handleLocationSearchDelegate?.pickLocation(placemark: selectedItem)
        dismiss(animated: true, completion: nil)
    }
}

extension LocationTableView: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        self.matchingItems.removeAll()
        guard let searchBarText = searchController.searchBar.text
            else { return }
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchBarText
        request.region = MKCoordinateRegion()
        let search = MKLocalSearch(request: request)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            search.start { response, _ in
                guard let response = response else { return }
                for item in response.mapItems {
                    self.matchingItems.append(item)
                    self.tableView.reloadData()
                }
            }
        }
    }
}
