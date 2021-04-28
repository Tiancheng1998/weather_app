//
//  ViewController.swift
//  weather_app
//
//  Created by Tony Wang on 4/23/21.
//  Copyright © 2021 Tony_Wang. All rights reserved.
//

import UIKit
import SnapKit

class CityMainViewController: UIViewController {
    
    
    private var cityLabel: UILabel!
    // init by default initializer
    private var addCity: UIBarButtonItem!
    private let citiesTable: UITableView = {
        let tv = UITableView()
        tv.separatorStyle = .none
        return tv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        WeatherData.shared.mainVC = self
        
        setupAddCityButton()
        setupCityLabel()
        setupTableView()

        setupConstraints()
        
    }
    
    private func setupAddCityButton() {
        addCity = UIBarButtonItem(title: "+", style: .plain, target: self, action: #selector(addCityButtonTapped))
        addCity.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Helvetica", size: 30.0)!], for: .normal)
        navigationItem.setLeftBarButton(addCity, animated: true)
        
    }
    
    private func setupCityLabel() {
        cityLabel = UILabel()
        cityLabel.text = "Cities"
        cityLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        cityLabel.textAlignment = .left
        view.addSubview(cityLabel)
        
    }
    
    private func setupTableView() {
        citiesTable.register(CityTableViewCell.self, forCellReuseIdentifier: CityTableViewCell.identifier)
        citiesTable.dataSource = self
        citiesTable.delegate = self
        view.addSubview(citiesTable)
    }
    
    
    
    private func setupConstraints() {
        cityLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(20)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
        }
        
        citiesTable.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(cityLabel.snp.bottom).offset(10)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }

    }
    
    // MARK: Actions
    @objc func addCityButtonTapped() {
        let vc = EnterLocationViewController()
        vc.MainVC = self
        present(vc, animated: true, completion: nil)
        
    }
    
    func refreshUI() {
        citiesTable.reloadData()
    }
    
    func addCity(cityName: String, lat: Double, lon: Double) {
        WeatherData.shared.addCity(name: cityName, lat: lat, lon: lon)
        citiesTable.reloadData()
    }


}

extension CityMainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return WeatherData.shared.cityNames.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.citiesTable.dequeueReusableCell(withIdentifier: CityTableViewCell.identifier, for: indexPath) as! CityTableViewCell
        let cityName = WeatherData.shared.cityNames[indexPath.row]
        if let city = WeatherData.shared.data[cityName] {
            let firstDay = city.daily[0]
            let sunrise = WeatherData.shared.unix2hm(for: firstDay.sunrise, tzOff: city.timezoneOffset)
            let sunset = WeatherData.shared.unix2hm(for: firstDay.sunset, tzOff: city.timezoneOffset)
            let temperature = firstDay.temp.day
            cell.setContent(titleText: cityName, sunriseTime: sunrise, sunsetTime: sunset, weather: firstDay.weather[0].main, temp: temperature)
            return cell
        }
        cell.setContent(titleText: cityName, sunriseTime: "__:__ AM", sunsetTime: "__:__ PM", weather: "Clouds", temp: nil)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if WeatherData.shared.data[WeatherData.shared.cityNames[indexPath.row]] != nil {
            let vc = WeatherDailyViewController()
            vc.cityName = WeatherData.shared.cityNames[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            WeatherData.shared.deleteCity(name: WeatherData.shared.cityNames[indexPath.row])
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if WeatherData.shared.data[WeatherData.shared.cityNames[indexPath.row]] != nil {
            return true
        }
        return false
    }
}

