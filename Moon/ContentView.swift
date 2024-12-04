//
//  ContentView.swift
//  Moon
//
//  Created by Dari Dennis on 11/30/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var locationManager = LocationManager()
    @State private var selectedTab: String = "MoonView" // Default to MoonView tab

    var body: some View {
        NavigationView {
            if let lat = locationManager.userLatitude, let lon = locationManager.userLongitude {
                TabView(selection: $selectedTab) {
                    MoonView(latitude: lat, longitude: lon)
                        .tabItem {
                            Label("Moon View", systemImage: "moon.stars")
                        }
                        .tag("MoonView") // Tag for the MoonView tab
                    MoonWebView()
                        .tabItem {
                            Label("Web View", systemImage: "sun.max")
                        }
                        .tag("SunView") // Tag for the SunView tab
                }
                .toolbar {
                    if selectedTab == "MoonView" {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            NavigationLink(destination: SettingsView()) {
                                Image(systemName: "gearshape")
                                    .imageScale(.large)
                            }
                        }
                    }
                }
            } else {
                Text("Fetching your location...")
            }
        }
    }
}


#Preview {
    ContentView()
}
