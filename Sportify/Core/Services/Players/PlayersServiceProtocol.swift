//
//  PlayersServiceProtocol.swift
//  Sportify
//
//  Created by Elsobky on 09/05/2026.
//

import Foundation

protocol PlayersServiceProtocol {

    func getPlayers(
        sport: APISport,
        teamId: Int,
        completion: @escaping (
            Result<BaseResponse<[Player]>, NetworkError>
        ) -> Void
    )
}
