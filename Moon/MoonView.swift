//
//  MoonView.swift
//  Moon
//
//  Created by Dari Dennis on 11/30/24.
//

import Foundation
import SwiftUI

struct MoonView: View {
    @StateObject private var moonHelper = MoonHelper()
    @State private var currentTime: Double = 0.0
    
    let latitude: Double
    let longitude: Double
    let today = Date.now
    let totalMinutes = 24 * 60.0
    
    var body: some View {
        ScrollView {
            if moonHelper.isLoading {
                ProgressView("Loading data...")
            } else if let errorMessage = moonHelper.errorMessage {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
            } else if let moon = moonHelper.moonPhase {
                if let moon = moonHelper.moonPhase, let sun = moonHelper.sun {
                    let goldenHour = adjustTime(by: -60, from: sun.sunset_timestamp)
                    let blueHour = adjustTime(by: 10,from: sun.sunset_timestamp)
                    let goldenMinute = timeInMinutes(from: goldenHour)
                    let blueMinute = timeInMinutes(from: blueHour)
                    
                    VStack {
                        
                        Text("Today: \(today.formatted(.dateTime.day().month().year()))")
                            .font(.title2)
                        
                        Image(getMoonImage(emoji: moon.emoji) ?? "NewMoon")
                            .resizable()
                            .frame(width: 270, height: 270)
                            .padding()
                        Text("Moon phase: \(moon.phase_name)")
                        Text("Illumination: \(moon.illumination)")
                            .padding()
                        ZStack {
                            // Background bar
                            RoundedRectangle(cornerRadius: 5)
                                .fill(Color.gray.opacity(0.3))
                                .frame(height: 10)
                            
                            Circle()
                                .fill(Color.orange)
                                .overlay(Circle().stroke(Color.yellow))
                                .frame(width: 15, height: 15)
                                .offset(x: CGFloat((goldenMinute / totalMinutes) * 300 - 150))
                            
                            Circle()
                                .fill(Color.blue)
                                .overlay(Circle().stroke(Color.yellow))
                                .frame(width: 15, height: 15)
                                .offset(x: CGFloat((blueMinute / totalMinutes) * 300 - 150))
                            
                            // Picker-like indicator
                            Image(currentTime > blueMinute ? "Moon" : "Sun")
                            //                            .fill(Color.white)
                            //                            .overlay(Circle().stroke(Color.blue, lineWidth: 2))
                                .resizable()
                                .frame(width: 30, height: 30)
                                .offset(x: CGFloat((currentTime / totalMinutes) * 300 - 150))
                        }
                        .frame(width: 300)
                        .padding()
                        
                        Image("Sun")
                            .resizable()
                            .frame(width: 170, height: 170)
                            .padding()
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.yellow)
                                .frame(width: 350, height: 50)
                            Text("Golden hour: \(goldenHour ?? sun.sunset_timestamp)")
                        }
                        
                        Text("Sunset: \(sun.sunset_timestamp)")
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.blue)
                                .frame(width: 350, height: 50)
                            Text("Blue hour: \(blueHour ?? sun.sunset_timestamp)")
                        }
                    }
                } else {
                    Text("Fetching space info...")
                }
            }
        }
    }
    
    func getMoonImage(emoji: String) -> String? {
        let image = PhaseImage(emoji: emoji)
        var displayImage: String
        
        switch image {
        case .first_quarter:
            displayImage = "FirstQuarter"
        case .full_moon:
            displayImage = "FullMoon"
        case .new_moon:
            displayImage = "NewMoon"
        case .last_quarter:
            displayImage = "LastQuarter"
        case .waning_gibbous:
            displayImage = "WaningGibbous"
        case .waning_crescent:
            displayImage = "WaningCrescent"
        case .waxing_gibbous:
            displayImage = "WaxingGibbous"
        case .waxing_crescent:
            displayImage = "WaxingCrescent"
        default:
            displayImage = "NewMoon"
        }
        return displayImage
    }
    
    func adjustTime(by minutes: Int, from timeString: String) -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        
        // Parse the input time string
        guard let date = formatter.date(from: timeString) else {
            return nil // Return nil if input is invalid
        }
        
        // Adjust the time by the specified number of minutes
        let adjustedDate = Calendar.current.date(byAdding: .minute, value: minutes, to: date)
        
        // Format the adjusted date back into a string
        return adjustedDate.map { formatter.string(from: $0) }
    }
    
    // Helper to calculate the current time in minutes from midnight
    func timeInMinutes(from timeString: String? = nil) -> Double {
        let calendar = Calendar.current
        
        if let timeString = timeString {
            // Parse the provided time string
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            
            if let date = formatter.date(from: timeString) {
                let components = calendar.dateComponents([.hour, .minute], from: date)
                let hours = components.hour ?? 0
                let minutes = components.minute ?? 0
                return Double((hours * 60) + minutes)
            } else {
                // Invalid time string
                return -1 // Use -1 as an error indicator
            }
        } else {
            // Use the current time
            let now = Date()
            let components = calendar.dateComponents([.hour, .minute], from: now)
            let hours = components.hour ?? 0
            let minutes = components.minute ?? 0
            return Double((hours * 60) + minutes)
        }
    }
}

#Preview {
    MoonView(latitude: 37.7749, longitude: -122.4194) // Example coordinates for San Francisco
}
