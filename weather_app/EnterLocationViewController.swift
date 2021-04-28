//
//  EnterLocationViewController.swift
//  weather_app
//
//  Created by Tony Wang on 4/28/21.
//  Copyright © 2021 Tony_Wang. All rights reserved.
//

import UIKit
import CoreLocation


// for autocomplete: https://stackoverflow.com/questions/33380711/how-to-implement-auto-complete-for-address-using-apple-map-kit

class EnterLocationViewController: UIViewController {
    
    var MainVC: CityMainViewController!
    private let search: UISearchBar = {
        let sb = UISearchBar()
        sb.prompt = "Enter City Name"
        return sb
    }()
    private let geocoder = CLGeocoder()
    private let errorMessage: UILabel = {
        let e = UILabel()
        e.textColor = .red
        e.isHidden = true
        return e
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        // Do any additional setup after loading the view.
        search.delegate = self
        view.addSubview(search)
        view.addSubview(errorMessage)
        search.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(100)
            make.width.equalToSuperview()
            make.height.equalTo(100)
        }
        errorMessage.snp.makeConstraints { (make) in
            make.top.equalTo(search.snp.bottom)
            make.centerX.equalToSuperview()
        }
    }
    
}

extension EnterLocationViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if let text = search.text {
            geocoder.geocodeAddressString(text) {
                placemarks, error in
                if let _ = error {
                    self.errorMessage.isHidden = false
                    self.errorMessage.text = "failed to retrieve latitude and lognitude"
                    return
                }
                let placemark = placemarks?.first
                let lat = placemark?.location?.coordinate.latitude
                let lon = placemark?.location?.coordinate.longitude
                
                if let latitude = lat, let longitude = lon {
                    self.errorMessage.isHidden = true
                    self.MainVC.addCity(cityName: text, lat: Double(latitude), lon: Double(longitude))
                    self.dismiss(animated: true, completion: nil)
                } else {
                    self.errorMessage.isHidden = false
                    self.errorMessage.text = "failed to retrieve latitude and lognitude"
                }
            }
        }
    }
}
