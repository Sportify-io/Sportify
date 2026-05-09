//
//  BaseResponse.swift
//  Sportify
//
//  Created by Elsobky on 09/05/2026.
//

import Foundation

struct BaseResponse<T: Decodable>: Decodable {
    let success: Int
    let result: T?
}
