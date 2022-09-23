//
//  AR_WeatherApp.swift
//  AR Weather
//
//  Created by Ali Eldeeb on 9/21/22.
//

import SwiftUI

@main
struct AR_WeatherApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(ARViewModel.singleton)
        }
    }
}
