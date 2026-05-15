//
//  NetworkError.swift
//  Sportify
//
//  Created by Elsobky on 09/05/2026.
//

import Foundation

enum NetworkError: LocalizedError, Equatable{

    case invalidURL
    case noInternet
    case decodingError
    case serverError(String)
    case unauthorized
    case unknown

    var errorDescription: String? {

        switch self {

        case .invalidURL:
            return "Invalid URL"

        case .noInternet:
            return "No internet connection"

        case .decodingError:
            return "Failed to decode response"

        case .serverError(let message):
            return message

        case .unauthorized:
            return "Unauthorized access"

        case .unknown:
            return "Something went wrong"
        }
    }
}
