//
//  ZodiacView.swift
//  Moon
//
//  Created by Dari Dennis on 12/3/24.
//

import Foundation
import SwiftUI

struct ZodiacView: View {
    @StateObject private var moonHelper = MoonHelper()
    @State private var errorMessage: String?
    @State private var currentTime: Double = 0.0
    
    let latitude: Double
    let longitude: Double
    
    var body: some View {
        VStack {
            if moonHelper.isLoading {
                ProgressView("Loading data...")
            } else if let errorMessage = moonHelper.errorMessage {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
            } else if let zodiac = moonHelper.zodiac {
                Text("Moon Sign: \(zodiac.moonSign)")
                Text("Sun Sign: \(zodiac.sunSign)")
            } else {
                Text("Loading zodiac info...")
            }
        }
    }
}

#Preview {
    ZodiacView(latitude: 37.7749, longitude: -122.4194)
}
