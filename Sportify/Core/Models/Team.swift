//
//  Team.swift
//  Sportify
//
//  Created by Elsobky on 09/05/2026.
//

import Foundation

struct Team: Decodable {

    let teamKey: Int
    let teamName: String?
    let teamLogo: String?
    let players: [Player]?

    enum CodingKeys: String, CodingKey {

        case teamKey = "team_key"
        case teamName = "team_name"
        case teamLogo = "team_logo"
        case players = "players"
    }
}
