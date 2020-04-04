//
//  ViewController.swift
//  weatherApp
//
//  Created by Apple on 31/03/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {

    @IBOutlet weak var searchValButton: UITextField!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var temperatureVal: UILabel!
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var citySeach: UITextField!
    var cityNameEntered = ""
    
    let weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        // confirming the delegate to get the FinalWeatherModel data
        weatherManager.delegate = self
        citySeach.delegate = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func currentLocation(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
}

//MARK: - UITextFieldDelegate

// text field delegate methods
extension ViewController: UITextFieldDelegate {
    // search city names to get the weather data
    @IBAction func searchPressed(_ sender: UIButton) {
        weatherManager.getCityAPI(city: citySeach.text!)
        cityNameEntered = citySeach.text!
        citySeach.endEditing(true)
    }
    
    // triggers when the user clicks done or return in keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        weatherManager.getCityAPI(city: citySeach.text!)
        cityNameEntered = citySeach.text!
        citySeach.endEditing(true)
        return true
    }
    
    // checks if the user ends editing.
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if (textField.text != "") {
            return true
        } else {
            return false
        }
    }
    
    // called after the textFieldShouldEndEditing based on the bool value returned.
    // text field ends editing only when the user types any value.
    func textFieldDidEndEditing(_ textField: UITextField) {
        citySeach.text = ""
    }
}

//MARK: - WeatherProtocol Subs

// weather protocol subs
extension ViewController: weatherProtocol {
    // weather protocol method to get the weather model.
    func didUpdateWeather(weather: FinalWeatherModel) {
        // Main thread to show the data in UI
        DispatchQueue.main.async {
            self.cityName.text = weather.cityName
            self.temperatureVal.text = weather.temp_string
            self.weatherImage.image = UIImage(systemName: weather.weatherIcon)
        }
    }
    
    // if there comes any network error or data mismatch with the model
    func didFailUpdate(err: Error) {
        DispatchQueue.main.async {
            self.citySeach.text = self.cityNameEntered
            let alert = UIAlertController(title: "City Name Invalid", message: "Please check the City Name entered", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
                print("No value associated with City Name")
            }))
            self.present(alert, animated: true, completion: nil)
        }
        print(err)
    }

}

//MARK: - Location Manager

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
//            locationManager.stopUpdatingLocation()
            let lati = location.coordinate.latitude
            let long = location.coordinate.longitude
            weatherManager.getCoordinatesAPI(latitude: lati, longitude: long)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

