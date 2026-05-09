//
//  EventServiceProtocol.swift
//  Sportify
//
//  Created by Elsobky on 09/05/2026.
//

import Foundation

protocol FixturesServiceProtocol {

    func getFixtures(
        sport: APISport,
        leagueId: Int,
        from: Date,
        to: Date,
        completion: @escaping (
            Result<BaseResponse<[Event]>, NetworkError>
        ) -> Void
    )
}
