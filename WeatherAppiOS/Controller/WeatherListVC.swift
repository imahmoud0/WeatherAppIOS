//
//  WeatherListVC.swift
//  WeatherAppiOS
//
//  Created by Mahmoud Ibrahmi on 12/08/2020.
//  Copyright © 2020 brahmi. All rights reserved.
//

import UIKit
import MapKit
import component

protocol HandleLocationSearch {
    func pickLocation(placemark: MKPlacemark)
}

@available(iOS 13.0, *)
class WeatherListVC: UIViewController, UISearchBarDelegate {
    
    // MARK: - IBOutlet
    @IBOutlet weak var weatherTableView: UITableView!
    
    // MARK: - Variables
    var currentLocation = CLLocation()
    var weatherList: [WeatherData] = []
    var townResult = [Town]()
    var townModels = [TownModel]()
    var manager = Manager()
    let locationManager = CLLocationManager()
    var resultSearchController: UISearchController?

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self

        // Add user location automatically when the app starts
        getCurrentWeather()
        
        setupsearch()
    }

    override func viewWillAppear(_ animated: Bool) {
        townResult = manager.getTown()
        getWeatherData()
    }

    // MARK: - Setup search view
    func setupsearch() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()

        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationTableView") as? LocationTableView
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable

        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true

        locationSearchTable!.handleLocationSearchDelegate = self

        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for places"
        searchBar.returnKeyType = .done
        searchBar.delegate = self
        navigationItem.searchController = resultSearchController
    }

    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailsSegue" {
            if let viewcontroller = segue.destination as? WeatherDetailVC {
                viewcontroller.twonModel = sender as? TownModel
            }
        }
    }

    // MARK: - Get Weather  Data from APIs
    
    func getWeatherData() {
        guard Reachability.isConnectedToNetwork() else {
            let title = "No Internet connection"
            let message = "Please ensure you are connected to the Internet"
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }
        self.townModels.removeAll()
        let dispatch = DispatchGroup()
        let towns = townResult.unique {$0.name ?? ""}
        for town in towns {
            dispatch.enter()
            let url = "\(Config.baseUrl)lat=\(town.latitude)&lon=\(town.longitude)\(Config.apiKey)\(Config.units)\(Config.units)"
            guard let requestURL = URL(string: url) else { return }
            
            Service.shared.getData(requestURL, callback: { weather, _ in
                self.townModels.append(TownModel(town: town, weather: weather))
                DispatchQueue.main.async {
                    self.weatherTableView.reloadData()
                }
                dispatch.leave()
            })
        }
        DispatchQueue.global().async {
            dispatch.notify(queue: .main, execute: {
                self.weatherTableView.reloadData()
            })
        }
    }

    func getCurrentWeather() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            self.locationManager.startUpdatingLocation()
            let geoCoder = CLGeocoder()
            DispatchQueue.main.async {
                geoCoder.reverseGeocodeLocation(self.currentLocation, completionHandler: { (placemarks, _) -> Void in
                    if let cityName = placemarks?.last?.locality {
                        let town = self.manager.addTown()
                        town.name = cityName
                        town.latitude = self.currentLocation.coordinate.latitude
                        town.longitude = self.currentLocation.coordinate.longitude
                    }
                })
            }
        }
    }

}

// MARK: - Extensions & Delegates

@available(iOS 13.0, *)
extension WeatherListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return townModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("WeatherCell", owner: self, options: nil)?.first as! WeatherCell
        setUpCell(indexPath, cell: cell)
        return cell
    }

    func setUpCell(_ index: IndexPath, cell: WeatherCell) {
        guard townModels.count > index.row else { return }
        let currentWeather = townModels[index.row].weather.current
        if let name = townModels[index.row].town.name {
            cell.cityName.text = name
        }
        if let weather = currentWeather?.weather, !weather.isEmpty {
            cell.weatherState.text = weather[0].weatherDescription
            cell.weatherIcon.image = UIImage(named: (weather[0].icon ?? ""))
        }
        if let temp = currentWeather?.temp {
            cell.weatherTemperature.text = Int(temp).description
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "detailsSegue", sender: townModels[indexPath.row])
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        townModels.insert(townModels.remove(at: sourceIndexPath.row), at: destinationIndexPath.row)
        weatherTableView.reloadData()
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let cityName = self.townModels[indexPath.row].town.name {
                manager.deleteTown(name: cityName )
                self.townModels.remove(at: indexPath.row)
                self.weatherTableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
}

@available(iOS 13.0, *)
extension WeatherListVC: HandleLocationSearch {
    func pickLocation(placemark: MKPlacemark) {
        resultSearchController?.searchBar.text = ""
        if let cityName = placemark.locality {
            let town = self.manager.addTown()
            town.name = cityName
            town.latitude = placemark.coordinate.latitude
            town.longitude = placemark.coordinate.longitude
            townResult = manager.getTown()
            getWeatherData()
        }
    }
}

// MARK: - CLLocationManagerDelegate

@available(iOS 13.0, *)
extension WeatherListVC: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {

        case .authorizedWhenInUse:
            print("allowed")

        case .notDetermined:
            print("not allow")

        case .denied, .restricted:
            print("setting")

            let alert = UIAlertController(
                title: "Location services for this app are disabled",
                message: "In order to get your current location, please open Settings for this app, choose \"Location\"  and set \"Allow location access\" to \"While Using the App\".",
                preferredStyle: .alert
            )
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let openSettingsAction = UIAlertAction(title: "Open Settings", style: .default)
            { _ in
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url as URL)
                }
            }
            alert.addAction(cancelAction)
            alert.addAction(openSettingsAction)
            present(alert, animated: true, completion: nil)
        default:
            print("default")
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            self.currentLocation = location
            self.locationManager.stopUpdatingLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error.localizedDescription)")
    }
}

extension Array {
  func unique<T:Hashable>(map: ((Element) -> (T)))  -> [Element] {
      var set = Set<T>() //the unique list kept in a Set for fast retrieval
      var arrayOrdered = [Element]() //keeping the unique list of elements but ordered
      for value in self {
          if !set.contains(map(value)) {
              set.insert(map(value))
              arrayOrdered.append(value)
          }
      }
      return arrayOrdered
    }
}
