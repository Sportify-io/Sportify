//
//  TeamService.swift
//  Sportify
//
//  Created by Elsobky on 09/05/2026.
//

import Foundation

final class TeamsService: TeamsServiceProtocol {

    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol = APIClient.shared) {
        self.apiClient = apiClient
    }

    func getTeams(
        sport: APISport,
        leagueId: Int,
        completion: @escaping (
            Result<BaseResponse<[Team]>, NetworkError>
        ) -> Void
    ) {

        apiClient.request(
            endpoint: .teams(
                sport: sport,
                leagueId: leagueId
            ),
            completion: completion
        )
    }
}
