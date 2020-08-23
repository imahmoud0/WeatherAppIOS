//
//  WeatherDetailVC.swift
//  WeatherAppiOS
//
//  Created by Mahmoud Ibrahmi on 13/08/2020.
//  Copyright © 2020 brahmi. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
class WeatherDetailVC: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var weatherDetailTV: UITableView!
    @IBOutlet weak var hourlyColloctionView: UICollectionView!
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var weatherState: UILabel!
    @IBOutlet weak var weatherTemp: UILabel!
        
    // MARK: - Variables
    var twonModel: TownModel!
    var nameCity: String!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        self.hourlyColloctionView.register(UINib(nibName: "HourlyCell", bundle: nil), forCellWithReuseIdentifier: "hourlyCell")
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }

    func setUpUI() {
        cityName.text = twonModel.town.name
        if let tem = twonModel.weather.current?.temp {
            weatherTemp.text = "\(Int(tem).description)°"
        }
        if let weather = twonModel.weather.current?.weather, !weather.isEmpty {
            weatherState.text = (weather[0].weatherDescription)
        }
    }
}

// MARK: - Extensions & Delegates

@available(iOS 13.0, *)
extension WeatherDetailVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return twonModel.weather.daily?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("WeatherDetailCell", owner: self, options: nil)?.first as! WeatherDetailCell
        setUpCell(indexPath, cell: cell)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }

    func setUpCell(_ index: IndexPath, cell: WeatherDetailCell) {
        guard let dailyWeather = twonModel.weather.daily?[index.row] else { return }
        if let weather = dailyWeather.weather, !weather.isEmpty {
            cell.weatherIcon.image = UIImage(named: weather[0].icon!)
        }
        if let date = dailyWeather.dt {
            let day = Helper.shared.getDayFromTime(time: date)
            cell.dayName.text = day
        }
        if let max = dailyWeather.temp?.max {
            cell.temperatureHigh.text = Int(max).description
        }
        if let min = dailyWeather.temp?.min {
            cell.temperatureLow.text  = Int(min).description
        }
        if let humidity = dailyWeather.humidity {
            cell.humidity.text = "Humidity: \(humidity) %"
        }
        if let wind = dailyWeather.windSpeed {
            cell.wind.text = "Wind: \(wind) m/s"
        }
        if let rain = dailyWeather.rain {
            cell.rain.text = "Rain: \(rain) mm"
        } else {
            cell.rain.text = ""
        }
    }
}

// MARK: - Collection View data source

@available(iOS 13.0, *)
extension WeatherDetailVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return twonModel.weather.hourly?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "hourlyCell", for: indexPath as IndexPath) as! HourlyCell
        setUpHourlyCell(indexPath, cell: cell)
        return cell
    }
    
    func setUpHourlyCell(_ index: IndexPath, cell: HourlyCell) {
        guard let hourly = twonModel.weather.hourly?[index.row] else { return }
        if let temp = hourly.temp {
            cell.temp.text = Int(temp).description
        }
        if let weather = hourly.weather, !weather.isEmpty {
            cell.icon.image = UIImage(named: weather[0].icon!)
        }
        if let date = hourly.dt {
            let time = Helper.shared.getTimeFromDate(time: date)
            cell.time.text = time.description
        }
        if index.row == 0 {
            cell.time.text = "now"
        }
    }
}

@available(iOS 13.0, *)
extension WeatherDetailVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSize = (self.hourlyColloctionView.frame.width / 6)
        return CGSize(width: itemSize, height: 98)
    }
}
