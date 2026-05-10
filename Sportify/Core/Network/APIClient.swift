//
//  APIClient.swift
//  Sportify
//
//  Created by Elsobky on 09/05/2026.
//

import Foundation
import Alamofire

protocol APIClientProtocol {

    func request<T: Decodable>(
        endpoint: EndPoint,
        completion: @escaping (
            Result<T, NetworkError>
        ) -> Void
    )
}

final class APIClient: APIClientProtocol {

    static let shared = APIClient()

    private init() {}

    func request<T: Decodable>(
        endpoint: EndPoint,
        completion: @escaping (
            Result<T, NetworkError>
        ) -> Void
    ) {
        guard ReachabilityManager.shared.isReachable else {

                completion(.failure(.noInternet))
                return
        }
        AF.request(
            endpoint.url,
            method: endpoint.method,
            parameters: endpoint.parameters
        )
        .validate()
        .responseDecodable(of: T.self) { response in

            switch response.result {

            case .success(let data):

                completion(.success(data))

            case .failure(let error):

                completion(
                    .failure(
                        .serverError(error.localizedDescription)
                    )
                )
            }
        }
    }
}
