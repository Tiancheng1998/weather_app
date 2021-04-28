//
//  WeatherDailyViewController.swift
//  weather_app
//
//  Created by Tony Wang on 4/25/21.
//  Copyright © 2021 Tony_Wang. All rights reserved.
//

import UIKit

import SnapKit

class WeatherDailyViewController: UIViewController {
    
    // data
    public var cityName:String!
    private var weatherData: CityData {
        get {
            return WeatherData.shared.data[cityName]!
        }
    }
    
    // views
    private var cityNameLabel: UILabel = {
        let cityNameLabel = UILabel()
        cityNameLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        cityNameLabel.textAlignment = .left
        return cityNameLabel
    }()
    private let dailyTable: UITableView = {
        let tv = UITableView()
        tv.separatorStyle = .none
        return tv
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
        setupCityNameLabel()
        setupTableView()
        
        
    }
    
    private func setupCityNameLabel() {
        cityNameLabel.text = cityName
        view.addSubview(cityNameLabel)
        
        cityNameLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(20)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
        }
    }
    

    
    private func setupTableView() {
        dailyTable.register(CityTableViewCell.self, forCellReuseIdentifier: CityTableViewCell.identifier)
        dailyTable.dataSource = self
        dailyTable.delegate = self
        view.addSubview(dailyTable)
        
        dailyTable.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(cityNameLabel.snp.bottom).offset(10)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    


}

extension WeatherDailyViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CityTableViewCell.identifier, for: indexPath) as! CityTableViewCell
        let city = self.weatherData
        if indexPath.row < city.daily.count {
            let day = city.daily[indexPath.row]
            let sunrise = WeatherData.shared.unix2hm(for: day.sunrise)
            let sunset = WeatherData.shared.unix2hm(for: day.sunset)
            let dayformatted = WeatherData.shared.unix2Date(for: day.dt)
            cell.setContent(titleText: dayformatted, sunriseTime: sunrise, sunsetTime: sunset, weather: day.weather[0].main, temp: day.temp.day)
            return cell
        }
        return cell
        
//        cell.setContent(titleText: "__/__", sunriseTime: "__:__ AM", sunsetTime: "__:__ PM", weather: "sunny", temp: nil)
//        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    
}
