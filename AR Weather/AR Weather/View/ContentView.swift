//
//  ContentView.swift
//  AR Weather
//
//  Created by Ali Eldeeb on 9/21/22.
//

import SwiftUI
import ARKit
import RealityKit
struct ContentView: View {
    @State var cityName: String = "London"
    @State var isSearchBarVisible: Bool = true
    @State var temp: String = "0"
    @State var condition: String = ""
    @ObservedObject var weatherVm = WeatherNetworkManagerViewModel()
    var body: some View {
        ZStack{
            ARViewDisplay()
            VStack {
                
                if isSearchBarVisible{
                    //search bar
                    SearchBar(cityName: $cityName)
                }
                
                Spacer()
                
                //search toggle
                SearchToggle(isSearchToggle: $isSearchBarVisible)
                    .transition(.scale)
            }
            .padding()
            //triggers an action whenever a certain variable changes, we will call this whenever the city name is changes
            .onChange(of: cityName) { newCity in
                weatherVm.fetchData(cityName: newCity)
            }
            .onReceive(weatherVm.$recievedWeatherData) { recievedData in
                    
                    temp = recievedData?.temperatureString ?? "0"
                    condition = recievedData?.conditionName ?? "Nothing here"
      
        }
        
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct SearchBar: View{
    @State var searchText: String = ""
    @Binding var cityName: String
   
    var body: some View{
        HStack{
            Image(systemName: "magnifyingglass.circle.fill")
                .font(.system(size: 30))
            TextField("Search", text: $searchText) { value in
              
            } onCommit: {
                //when the user has finished typing his text we need to store whats contained in another var which we will pass to the main view
                cityName = searchText
                
            }

        }
        .frame(width: UIScreen.main.bounds.width)
            .padding(.all)
            .background(Color.blue.opacity(0.25))
    }
}

struct SearchToggle: View{
    @Binding var isSearchToggle:Bool
    var body: some View{
        Button {
            withAnimation {
                //toggle search bar
                isSearchToggle.toggle()
            }
            
        } label: {
            Image(systemName: "magnifyingglass.circle.fill")
                .font(.system(size: 30))
        }

    }
}

struct ARViewDisplay: View{
    var body: some View{
        ARViewContainer().edgesIgnoringSafeArea(.all)
    }
}

struct ARViewContainer: UIViewRepresentable{
    typealias UIViewType = ARView
    
    func makeUIView(context: Context) -> ARView {
        //Note: If we want access to the ARViewModel singleton globally we need to make it an environent object
        ARViewModel.singleton.startARSession()
        return ARViewModel.singleton.arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        
    }
    
}
