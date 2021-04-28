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
    private let api = "https://api.openweathermap.org/data/2.5/onecall?lat=%f&lon=%f&exclude=minutely,hourly,alerts,current&units=imperial&appid=" + (Bundle.main.infoDictionary?["WEATHER_API_KEY"] as! String)
    
    private let defaults = UserDefaults.standard
    private let dformatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "MM/dd"
        return f
    }()
    private let hmformatter: DateFormatter = {
        let f = DateFormatter()
        f.amSymbol = "AM"
        f.pmSymbol = "PM"
        f.dateFormat = "hh:mm a"
        return f
    }()
    
    var mainVC: CityMainViewController?
    var data: [String : CityData] = [:]
    var cityNames: [String] {
        get {
            let arr = defaults.array(forKey: "cities")! as! [[Any]]
            let names = arr.map { $0[0] as! String }
            return names
        }
    }
    
    
    private func dataLoadDidComplete() -> Bool {
        return self.data.count == cityNames.count
    }
    
    func unix2Date(for timeStamp: Int) -> String {
        let epochTime = TimeInterval(timeStamp)
        let date = Date(timeIntervalSince1970: epochTime)
        return dformatter.string(from: date)
        
    }
    
    func unix2hm(for timeStamp: Int) -> String {
        let epochTime = TimeInterval(timeStamp)
        let date = Date(timeIntervalSince1970: epochTime)
        return hmformatter.string(from: date)
        
    }
    
    func deleteCity(name: String) {
        // force casting to let the bugs show
        // sometimes good to assert expected behavior
        let oldCities = defaults.array(forKey: "cities")! as! [[Any]]
        // copy on write
        let newCities = oldCities.filter { ($0[0] as! String) != name }
        defaults.set(newCities, forKey: "cities")
        data.removeValue(forKey: name)
    }
    
    // add individual city and loads its data
    func addCity(name: String, lat: Double, lon: Double) {
        if let _ = data[name] {
            return
        }
        var oldCities = defaults.array(forKey: "cities")!
        oldCities.append([name, lat, lon])
        defaults.set(oldCities, forKey: "cities")
        
        loadDataCity(for: name)
    }
    
    func getCoord(for name: String) -> [Double]? {
        for city in defaults.array(forKey: "cities")! as! [[Any]] {
            if city[0] as! String == name {
                return [city[1] as! Double, city[2] as! Double]
            }
        }
        return nil
    }
    
    // load all data based on user defaults, called at app launch
    func loadDataAll() {
        for c in cityNames {
            loadDataCity(for: c)
        }
    }
    
    // try? try! try do catch and throwing errors
    // Because the vend(itemNamed:) method propagates any errors it throws, any code that calls this method must either handle the errors—using a do-catch statement, try?, or try!—or continue to propagate them. (try does not handle error, merely propogating it)
    private func loadDataCity(for city: String) {
        // call api
        // add keyvalue pair to data
        let coord = getCoord(for: city)!
        let task = URLSession.shared.dataTask(with: URL(string: String(format: api, coord[0], coord[1]))!) { (data, _, error) in
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
                        self.mainVC?.refreshUI()
                    }
                }
            } catch {
                print(error)
            }
        }
        
        task.resume()
    }
    
//    class func dailyWeatherParser(for data: [String : Any]) -> [String : Any]{
//        let res: [String : Any] = [:]
//        return res
//    }
//    
    
}
