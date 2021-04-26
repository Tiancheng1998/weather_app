//
//  WeatherData.swift
//  weather_app
//
//  Created by Tony Wang on 4/24/21.
//  Copyright © 2021 Tony_Wang. All rights reserved.
//

import Foundation

enum condition {
    case sunny
    case cloudy
    case rainy
    case snowy
    case unknown
}

class WeatherData {
    
    static let shared = WeatherData()
    
    private let defaults = UserDefaults.standard
    
    var data: [String : [[String: Any]]] = [:]
    var cityNames: [String] {
        get {
            return defaults.stringArray(forKey: "cities")!.sorted()
        }
    }
    
    init() {
//        data = ["New York City": [["Temperature" : 81, "condition" : condition.sunny], ["Temperature" : 79, "condition" : condition.rainy], ["Temperature" : 81, "condition" : condition.cloudy] ]]
    }
    
    func deleteCity(name: String) {
        // force casting to let the bugs show
        // sometimes good to assert expected behavior
        var oldCities = defaults.stringArray(forKey: "cities")!
        // copy on write
        oldCities.remove(at: oldCities.firstIndex(of: name)!)
        defaults.set(oldCities, forKey: "cities")
        data.removeValue(forKey: name)
    }
    
    func addCity(name: String) {
        if let _ = data[name] {
            return
        }
        var oldCities = defaults.stringArray(forKey: "cities")!
        oldCities.append(name)
        defaults.set(oldCities, forKey: "cities")
        
        loadDataCity(for: name)
    }
    
    private func loadDataAll() {
        for c in cityNames {
            loadDataCity(for: c)
        }
    }
    
    private func loadDataCity(for city: String) {
        // call api
        // add keyvalue pair to data
    }
    
    class func dailyWeatherParser(for data: [String : Any]) -> [String : Any]{
        let res: [String : Any] = [:]
        return res
    }
    
    
}
