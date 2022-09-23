//
//  WeatherData.swift
//  AR Weather
//
//  Created by Ali Eldeeb on 9/21/22.
//

import Foundation

struct WeatherData: Codable{
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Codable{
    let temp: Double
}

struct Weather: Codable{
    let id: Int
    let main: String
}
