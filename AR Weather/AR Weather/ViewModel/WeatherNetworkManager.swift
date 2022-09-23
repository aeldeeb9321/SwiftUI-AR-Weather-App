//
//  WeatherNetworkManager.swift
//  AR Weather
//
//  Created by Ali Eldeeb on 9/21/22.
//

import Foundation

class WeatherNetworkManagerViewModel: ObservableObject{
    @Published var recievedWeatherData: WeatherModel?
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=YOURAPPID&units=imperial"
    //Feathc data
    func fetchData(cityName: String){
        let weatherURLString = "\(weatherURL)&q=\(cityName)"
        if let url = URL(string: weatherURLString){
            //URL session
            let session = URLSession(configuration: .default)
            //Fetching task
            let task = session.dataTask(with: url) { data, response, error in
                guard
                    let data = data,
                    error == nil,
                    let response = response as? HTTPURLResponse,
                    response.statusCode >= 200 && response.statusCode < 300
                else{
                    fatalError("\(String(describing: error?.localizedDescription))")
                }
                //decoded
                if let decodedData = self.decodeJSONData(recievedData: data){
                    //convert to a usable form
                    let decodedWeatherData = self.convertDecodedDataToUsableForm(decodedData: decodedData)
                    
                    //pass data
                    self.passData(decodedWeatherData)
                }
            }
            task.resume()
        }
        
    }
    //Accepts recieved data, decodes it, and stores it inside WeatherDataDecodedModel
    private func decodeJSONData(recievedData: Data) -> WeatherData?{
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(WeatherData.self, from: recievedData)
            return decodedData
        }catch{
            return nil
        }
    }
 
    private func convertDecodedDataToUsableForm(decodedData: WeatherData) -> WeatherModel{
        let weatherData = WeatherModel(cityName: decodedData.name, temperature: decodedData.main.temp, conditionId: decodedData.weather[0].id)
        return weatherData
    }
    
    //We want to pass the decodedWeatherData to our main function
    private func passData(_ weatherData: WeatherModel){
        DispatchQueue.main.async {
            self.recievedWeatherData = weatherData //so everytime a new set of data is recieved, our publish var will update an subscribers

        }
    }
}
