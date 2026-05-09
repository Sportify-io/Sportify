//
//  EndPoint.swift
//  Sportify
//
//  Created by Elsobky on 09/05/2026.
//

import Foundation
import Alamofire

enum EndPoint {

    case leagues(sport: APISport)

    case teams(
        sport: APISport,
        leagueId: Int
    )

    case fixtures(
        sport: APISport,
        leagueId: Int,
        from: Date,
        to: Date
    )
    case players(
        sport: APISport,
        teamId: Int
    )

    var path: String {

        switch self {

        case .leagues(let sport),
             .teams(let sport, _),
             .fixtures(let sport, _, _, _),
             .players(let sport, _):

            return "/\(sport.rawValue)/"
        }
    }


    var method: HTTPMethod {

        switch self {

        default:
            return .get
        }
    }


    var parameters: Parameters {

        switch self {

        case .leagues:

            return [
                "met": "Leagues",
                "APIkey": APIConstants.apiKey
            ]

        case .teams(_, let leagueId):

            return [
                "met": "Teams",
                "leagueId": leagueId,
                "APIkey": APIConstants.apiKey
            ]

        case .fixtures(_, let leagueId, let from, let to):

            return [
                "met": "Fixtures",
                "leagueId": leagueId,
                "from": from.toAPIFormat(),
                "to": to.toAPIFormat(),
                "APIkey": APIConstants.apiKey
            ]
    
        case .players(sport: _,let teamId):
            return [
                "met": "Players",
                "teamId": teamId,
                "APIkey": APIConstants.apiKey
            ]
        }
    }


    var url: String {
        return APIConstants.baseURL + path
    }
}
