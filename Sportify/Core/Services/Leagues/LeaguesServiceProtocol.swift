//
//  Untitled.swift
//  Sportify
//
//  Created by Elsobky on 09/05/2026.
//

import Foundation

protocol LeaguesServiceProtocol {

    func getLeagues(
        sport: APISport,
        completion: @escaping (
            Result<BaseResponse<[League]>, NetworkError>
        ) -> Void
    )
}
