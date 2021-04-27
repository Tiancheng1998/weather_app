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


// add more features
struct CityData: Codable{
    enum CodingKeys: String, CodingKey {
        case lat
        case lon
        case timezone
        case timezoneOffset = "timezone_offset"
        case daily
    }
    
    var lat: Double
    var lon: Double
    var timezone: String
    var timezoneOffset: Double
    var daily: [DailyData]
    
    struct DailyData: Codable{
        // CodingKeys is the codebook that tells the decoder what and how to decode
        enum CodingKeys: String, CodingKey {
            case dt
            case sunrise
            case sunset
            case moonrise
            case moonset
            case moonPhase = "moon_phase"
            case temp
            case humidity
            case windSpeed = "wind_speed"
            case weather
        }
        
        var dt: Int
        var sunrise: Int
        var sunset: Int
        var moonrise: Int
        var moonset: Int
        var moonPhase: Double
        var temp: Temperature
        var humidity: Int
        var windSpeed: Double
        var weather: [Weather]
        
        
        struct Temperature: Codable {
            var day: Double
            var min: Double
            var max: Double
            var night: Double
            var eve: Double
            var morn: Double
        }
        
        struct Weather: Codable {
            enum CodingKeys: String, CodingKey {
                case main
                case description
            }
            
            var main: String
            var description: String
        }
    }
}

class WeatherData {
    
    static let shared = WeatherData()
    private let api: String = "https://api.openweathermap.org/data/2.5/onecall?lat=22&lon=32&exclude=minutely,hourly,alerts,current&units=imperial&appid=" + (Bundle.main.infoDictionary?["WEATHER_API_KEY"] as! String)
    
    private let defaults = UserDefaults.standard
    
    var dataSource: MainVCDataSource?
    var data: [String : CityData] = [:]
    var cityNames: [String] {
        get {
            return defaults.stringArray(forKey: "cities")!.sorted()
        }
    }
    
//    init() {
//        data = ["New York City": [["Temperature" : 81, "condition" : condition.sunny], ["Temperature" : 79, "condition" : condition.rainy], ["Temperature" : 81, "condition" : condition.cloudy] ]]
//    }
    
    private func dataLoadDidComplete() -> Bool {
        return self.data.count == cityNames.count
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
    
    // try? try! try do catch and throwing errors
    // Because the vend(itemNamed:) method propagates any errors it throws, any code that calls this method must either handle the errors—using a do-catch statement, try?, or try!—or continue to propagate them. (try does not handle error, merely propogating it)
    private func loadDataCity(for city: String) {
        // call api
        // add keyvalue pair to data
        let task = URLSession.shared.dataTask(with: URL(string: api)!) { (data, _, error) in
            if let error = error {
                // error handling
                print(error)
                return
            }
            
            guard let dataUW = data else { return }
            
            do {
                let cityWeatherSummary = try JSONDecoder().decode(CityData.self, from: dataUW)
                self.data[city] = cityWeatherSummary
                
                if self.dataLoadDidComplete() {
                    DispatchQueue.main.async {
                        // update UI
                        self.dataSource?.refreshUI()
                    }
                }
            } catch {
                print(error)
            }
        }
        
        task.resume()
    }
    
    class func dailyWeatherParser(for data: [String : Any]) -> [String : Any]{
        let res: [String : Any] = [:]
        return res
    }
    
    
}
