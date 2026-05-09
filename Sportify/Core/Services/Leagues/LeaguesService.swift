//
//  LeaguesService.swift
//  Sportify
//
//  Created by Elsobky on 09/05/2026.
//

import Foundation

final class LeaguesService: LeaguesServiceProtocol {

    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol = APIClient.shared) {
        self.apiClient = apiClient
    }

    func getLeagues(
        sport: APISport,
        completion: @escaping (
            Result<BaseResponse<[League]>, NetworkError>
        ) -> Void
    ) {

        apiClient.request(
            endpoint: .leagues(sport: sport),
            completion: completion
        )
    }
}
