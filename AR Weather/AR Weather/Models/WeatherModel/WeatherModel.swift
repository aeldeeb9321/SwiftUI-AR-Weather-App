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
    
    var temperatureString: Double{
        return Double(String(format: "%.0f", temperature))!
    }
    //computedProperty always have to be a var
    var conditionName: String {
        switch conditionId{
            case 200...232: return "thunder"
            case 300...321: return "rainy"
            case 500...531: return "rainy"
            case 600...622: return "snow"
            case 700...780: return "fog"
            case 781: return "tornado"
            case 800: return "sunny"
            case 801...804: return "thunder"
            default: return "normal"
        }

    }
}
