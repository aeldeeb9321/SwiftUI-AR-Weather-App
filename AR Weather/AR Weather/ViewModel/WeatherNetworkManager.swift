//
//  WeatherNetworkManager.swift
//  AR Weather
//
//  Created by Ali Eldeeb on 9/21/22.
//

import Foundation

//We create the protocol in the same file that will use the protocol
protocol WeatherManagerDelegate{
    func didUpdateWeather(_ weatherManager: WeatherNetworkManager,weather: WeatherModel)
    func didFailWithError(error: Error)
}

class WeatherNetworkManager{
    var cityName = ""
    var delegate: WeatherManagerDelegate?
    //Feathc data
    func downloadData(fromURL url: URL, completionHandler: @escaping (_ data: Data?) -> Void){
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let data = data,
                error == nil,
                let response = response as? HTTPURLResponse,
                response.statusCode >= 200 && response.statusCode < 300
            else{
                print("Error downloading data.")
                completionHandler(nil)
                return
            }
            completionHandler(data)
            
        }.resume()
    }
    //pass data
    private func passData(){
        guard let weatherURL = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(cityName)&appid=50cdbf283604cae768327b23d83bc887")  else{return}
        downloadData(fromURL: weatherURL) { returnedData in
            if let recievedData = returnedData{
                //decode data and then convert to usable form in app
                guard let weather = try? JSONDecoder().decode(WeatherData.self, from: recievedData) else{return}
                let id = weather.weather[0].id
                let temp = weather.main.temp
                let name = weather.name
                let decodedWeather = WeatherModel(cityName: name, temperature: temp, conditionId: id)
                
            }else{
                print("No data returned")
            }
        }
    }
}
