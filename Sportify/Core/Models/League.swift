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
    let leagueImageURL: String?
    let countryImageURL: String?

    enum CodingKeys: String, CodingKey {

        case leagueKey = "league_key"
        case leagueName = "league_name"
        case countryName = "country_name"
        case leagueImageURL = "league_logo"
        case countryImageURL = "country_logo"
    }
}
