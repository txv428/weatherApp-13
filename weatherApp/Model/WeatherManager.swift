//
//  weatherManager.swift
//  weatherApp
//
//  Created by Apple on 01/04/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
import CoreLocation

// weather protocol to send the data to viewcontroller class
protocol weatherProtocol {
    func didUpdateWeather(weather: FinalWeatherModel)
    func didFailUpdate(err: Error)
}

class WeatherManager {
    var delegate: weatherProtocol?
    
    // base url of the API
    let weatherAPIbaseURL: String = "https://api.openweathermap.org/data/2.5/weather?appid=c83be17b3cf78bb9dee835492dbea460&units=metric"
    
    // complete url based on the user entered, city name.
    func getCityAPI(city cityName: String) {
        let apiWithCityName = "\(weatherAPIbaseURL)&q=\(cityName)"
        requestURL(with: apiWithCityName)
    }
    
    // fetch url with latitude and longitudes
    func getCoordinatesAPI(latitude lat: CLLocationDegrees, longitude lon: CLLocationDegrees) {
        let apiWithCityName = "\(weatherAPIbaseURL)&lat=\(lat)&lon=\(lon)"
        requestURL(with: apiWithCityName)
    }
    
    //
    func requestURL(with apiURL: String) {
        // URL creation
        if let url_ = URL(string: apiURL) {
        
        // New URL Session created
            let urlSession = URLSession(configuration: .default)
            
            // dataTask to retrieve the json objects in the API
            let dataTask = urlSession.dataTask(with: url_) { (data, response, err) in
                if err != nil {
                    self.delegate?.didFailUpdate(err: err!)
                    return
                }
                
                if let dataResulted = data {
                    // if the data is not nil. calls the delegate method.
                    if let weatherOutput = self.dataParsing(weatherData: dataResulted) {
                        self.delegate?.didUpdateWeather(weather: weatherOutput)
                    }
                }
            }
            
            // resume task from suspended state
            dataTask.resume()
        }
    }
    
    // using JSONDecoder to decode the data into model
    func dataParsing(weatherData: Data) -> FinalWeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherModel.self, from: weatherData) as! WeatherModel
            let iconId = decodedData.weather[0].id
            let city_Name = decodedData.name
            let temp = decodedData.main.temp
            let output = FinalWeatherModel(weatherId: iconId, cityName: city_Name, temperature: temp)
            return output
        } catch {
            self.delegate?.didFailUpdate(err: error)
            return nil
        }
    }
}
