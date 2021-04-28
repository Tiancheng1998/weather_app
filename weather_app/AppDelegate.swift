//
//  AppDelegate.swift
//  weather_app
//
//  Created by Tony Wang on 4/23/21.
//  Copyright © 2021 Tony_Wang. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        if let _ = UserDefaults.standard.array(forKey: "cities") {
            WeatherData.shared.loadDataAll()
            return true
        }
        
//        print(Bundle.main.infoDictionary?["WEATHER_API_KEY"] as! String)
        // first time the app launches, need to init UserDefaults
        UserDefaults.standard.set([[Any]](), forKey: "cities")
        return true
        
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

