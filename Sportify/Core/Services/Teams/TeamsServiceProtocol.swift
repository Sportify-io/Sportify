//
//  TeamsServiceProtocol.swift
//  Sportify
//
//  Created by Elsobky on 09/05/2026.
//

import Foundation

protocol TeamsServiceProtocol {

    func getTeams(
        sport: APISport,
        leagueId: Int,
        completion: @escaping (
            Result<BaseResponse<[Team]>, NetworkError>
        ) -> Void
    )
}
