//
//  MockAPIClient.swift
//  Sportify
//
//  Created by Elsobky on 15/05/2026.
//

import XCTest
@testable import Sportify

class MockAPIClient: APIClientProtocol {
    var result: Any?
    var capturedEndpoint: EndPoint?
    var calledCount = 0

    func request<T: Decodable>(
        endpoint: EndPoint,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        calledCount += 1
        capturedEndpoint = endpoint

        guard let result = result as? Result<T, NetworkError> else {
            completion(.failure(.serverError("Mock result type mismatch")))
            return
        }
        completion(result)
    }
}
