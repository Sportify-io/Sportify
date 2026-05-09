//
//  ReachabilityManager.swift
//  Sportify
//
//  Created by Elsobky on 09/05/2026.
//

import Foundation
import Alamofire

final class ReachabilityManager {

    static let shared = ReachabilityManager()

    private let reachability = NetworkReachabilityManager()

    private init() {}

    var isReachable: Bool {
        return reachability?.isReachable ?? false
    }
}
