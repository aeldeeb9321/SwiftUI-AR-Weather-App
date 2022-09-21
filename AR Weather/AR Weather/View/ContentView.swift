//
//  ContentView.swift
//  AR Weather
//
//  Created by Ali Eldeeb on 9/21/22.
//

import SwiftUI

struct ContentView: View {
    @State var cityName: String
    @State var isSearchBarVisible: Bool = true
    var body: some View {
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
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(cityName: "London")
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
                print("typing in progress")
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
