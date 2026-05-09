//
//  TeamResponse.swift
//  Sportify
//
//  Created by Elsobky on 09/05/2026.
//

import Foundation

struct Player: Codable {

    let playerKey: Int?
    let playerName: String?
    let playerNumber: String?
    let playerCountry: String?
    let playerType: String?
    let playerAge: String?

    let playerYellowCards: String?
    let playerRedCards: String?
    let playerRating: String?

    let playerImage: String?

    enum CodingKeys: String, CodingKey {

        case playerKey = "player_key"
        case playerName = "player_name"
        case playerNumber = "player_number"
        case playerCountry = "player_country"
        case playerType = "player_type"
        case playerAge = "player_age"

        case playerYellowCards = "player_yellow_cards"
        case playerRedCards = "player_red_cards"
        case playerRating = "player_rating"

        case playerImage = "player_image"
    }
}
