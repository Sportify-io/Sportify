//
//  EventService.swift
//  Sportify
//
//  Created by Elsobky on 09/05/2026.
//

import Foundation

final class FixturesService: FixturesServiceProtocol {

    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol = APIClient.shared) {
        self.apiClient = apiClient
    }

    func getFixtures(
        sport: APISport,
        leagueId: Int,
        from: Date,
        to: Date,
        completion: @escaping (
            Result<BaseResponse<[Event]>, NetworkError>
        ) -> Void
    ) {

        apiClient.request(
            endpoint: .fixtures(
                sport: sport,
                leagueId: leagueId,
                from: from,
                to: to
            ),
            completion: completion
        )
    }
}
