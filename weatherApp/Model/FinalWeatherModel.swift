//
//  finalOutputModel.swift
//  weatherApp
//
//  Created by Apple on 01/04/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation

struct FinalWeatherModel {
    let weatherId: Int
    let cityName: String
    let temperature: Double
    
    // temperature with one decimal value.
    var temp_string: String {
        return String(format: "%.1f", temperature)
    }
    
    // To get the weather icon based on the conditionId from the API,
    var weatherIcon: String {
        switch weatherId {
        case 200...232:
            return "cloud.bolt.rain.fill"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max.fill"
        case 801...804:
            return "cloud"
        default:
            return "tornado"
        }
    }
}
