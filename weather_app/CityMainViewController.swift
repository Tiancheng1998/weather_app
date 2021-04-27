//
//  ViewController.swift
//  weather_app
//
//  Created by Tony Wang on 4/23/21.
//  Copyright © 2021 Tony_Wang. All rights reserved.
//

import UIKit
import SnapKit

protocol MainVCDataSource {
    func refreshUI()
}

class CityMainViewController: UIViewController, MainVCDataSource {
    
    
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
        WeatherData.shared.dataSource = self
        
        setupAddCityButton()
        setupCityLabel()
        setupTableView()

        setupConstraints()
        
    }
    
    private func setupAddCityButton() {
        addCity = UIBarButtonItem(title: "+", style: .plain, target: self, action: #selector(addCityTapped))
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
    @objc func addCityTapped() {
        WeatherData.shared.addCity(name: "New York City")
        citiesTable.reloadData()
    }
    
    func refreshUI() {
        citiesTable.reloadData()
    }


}

extension CityMainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return WeatherData.shared.cityNames.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.citiesTable.dequeueReusableCell(withIdentifier: CityTableViewCell.identifier, for: indexPath) as! CityTableViewCell
        cell.setContent(titleText: "New York City", sunriseTime: "6:30 AM", sunsetTime: "7:00 PM", weather: .sunny, temp: 78)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = WeatherDailyViewController()
        vc.cityName = "New York City"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            WeatherData.shared.deleteCity(name: WeatherData.shared.cityNames[indexPath.row])
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

