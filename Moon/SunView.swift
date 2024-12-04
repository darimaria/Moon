//
//  SunView.swift
//  Moon
//
//  Created by Dari Dennis on 12/1/24.
//

import Foundation
import SwiftUI

struct SunView: View {
    @StateObject private var moonHelper = MoonHelper()
    @State private var errorMessage: String?
    
    let latitude: Double
    let longitude: Double
    
    let today = Date.now
    
    var body: some View {
        VStack {
            if let sun = moonHelper.sun {
                VStack {
                    Text("Today: \(today.formatted(.dateTime.day().month().year().hour().minute()))")
                    Image("Sun")
                        .resizable()
                        .frame(width: 70, height: 70)
                    Text("Golden hour: \(sun.sunrise_timestamp)")
                }
            } else {
                Text("Fetching sun info...")
            }
        }
        .onAppear {
            moonHelper.fetchMoonData(lat: latitude, lon: longitude) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        break
                    case .failure(let error):
                        errorMessage = error.localizedDescription
                    }
                }
            }
        }
    }
}

#Preview {
    SunView(latitude: 37.7749, longitude: -122.4194)
}
