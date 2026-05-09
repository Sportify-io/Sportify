//
//  PlayersService.swift
//  Sportify
//
//  Created by Elsobky on 09/05/2026.
//

import Foundation

final class PlayersService: PlayersServiceProtocol {

    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol = APIClient.shared) {
        self.apiClient = apiClient
    }

    func getPlayers(
        sport: APISport,
        teamId: Int,
        completion: @escaping (
            Result<BaseResponse<[Player]>, NetworkError>
        ) -> Void
    ) {

        apiClient.request(
            endpoint: .players(
                sport: sport,
                teamId: teamId
            ),
            completion: completion
        )
    }
}
