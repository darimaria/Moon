//
//  MoonPhase.swift
//  Moon
//
//  Created by Dari Dennis on 11/30/24.
//

import Foundation

struct Zodiac: Decodable {
    let sunSign: String
    let moonSign: String
    
    enum CodingKeys: String, CodingKey {
        case sunSign = "sun_sign"
        case moonSign = "moon_sign"
    }
}

struct MoonPhase: Decodable {
    let phase: Double
    let phase_name: String
    let age_days: Int
    let lunar_cycle: String
    let emoji: String
    let illumination: String
    let moonrise: String
    let zodiac: Zodiac
    
    enum CodingKeys: String, CodingKey {
        case phase
        case phase_name
        case age_days
        case lunar_cycle
        case emoji
        case illumination
        case moonrise
        case zodiac
    }
}

enum PhaseImage: String, CaseIterable {
    case waning_crescent = "🌘"
    case waxing_crescent = "🌒"
    case waning_gibbous = "🌖"
    case waxing_gibbous = "🌔"
    case full_moon = "🌕"
    case new_moon = "🌑"
    case last_quarter = "🌗"
    case first_quarter = "🌓"
    case unknown
    
    init(emoji: String) {
        self = PhaseImage(rawValue: emoji) ?? .unknown
    }
}

struct Sun: Decodable {
    let sunrise_timestamp: String
    let sunset_timestamp: String
    let solar_noon: String
}

enum ZodiacSign: String, CaseIterable {
    case Aries = "♈️"
    case Taurus = "♉️"
    case Gemini = "♊️"
    case Cancer = "♋️"
    case Leo = "♌️"
    case Virgo = "♍️"
    case Libra = "♎️"
    case Scorpio = "♏️"
    case Sagittarius = "♐️"
    case Capricorn = "♑️"
    case Aquarius = "♒️"
    case Pisces = "♓️"
    case unknown
    
    init(emoji: String) {
        self = ZodiacSign(rawValue: emoji) ?? .unknown
    }
}
