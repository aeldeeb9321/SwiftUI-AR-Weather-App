//
//  WeatherModel.swift
//  AR Weather
//
//  Created by Ali Eldeeb on 9/21/22.
//

import Foundation

struct WeatherModel{
    
    let cityName: String
    let temperature: Double
    let conditionId: Int
    
    var temperatureString: String{
        return String(format: "%.1f", temperature)
    }
    //computedProperty always have to be a var
    var conditionName: String {
        switch conditionId{
            case 200...232: return "cloud.bolt"
            case 300...321: return "cloud.drizzle"
            case 500...531: return "cloud.rain"
            case 600...622: return "cloud.snow"
            case 700...780: return "cloud.fog"
            case 781: return "tornado"
            case 800: return "sun.max"
            case 801...804: return "cloud.bolt"
            default: return "cloud"
        }

    }
}
