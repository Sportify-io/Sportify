//
//  LeagueResponse.swift
//  Sportify
//
//  Created by Elsobky on 09/05/2026.
//

import Foundation

struct League: Decodable {

    let leagueKey: Int?
    let leagueName: String?
    let countryName: String?
    let leagueLogo: String?
    let countryLogo: String?

    enum CodingKeys: String, CodingKey {

        case leagueKey = "league_key"
        case leagueName = "league_name"
        case countryName = "country_name"
        case leagueLogo = "league_logo"
        case countryLogo = "country_logo"
    }
}
