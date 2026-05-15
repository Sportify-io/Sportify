//
//  FixtureResponse.swift
//  Sportify
//
//  Created by Elsobky on 09/05/2026.
//

import Foundation

struct Event: Codable, Equatable {
    let eventDate: String?
    let eventTime: String?
    
    let eventHomeTeam: String?
    let homeTeamLogo: String?
    
    let eventAwayTeam: String?
    let awayTeamLogo: String?
    
    let eventFinalResult: String?

    enum CodingKeys: String, CodingKey {
        case eventDate = "event_date"
        case eventTime = "event_time"
        case eventHomeTeam = "event_home_team"
        case homeTeamLogo = "home_team_logo"
        case eventAwayTeam = "event_away_team"
        case awayTeamLogo = "away_team_logo"
        case eventFinalResult = "event_final_result"
    }
}
