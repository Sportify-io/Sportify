//
//  DateUtil.swift
//  Sportify
//
//  Created by Elsobky on 09/05/2026.
//

import Foundation

extension Date {

    func toAPIFormat() -> String {

        let formatter = DateFormatter()

        formatter.dateFormat = "yyyy-MM-dd"

        return formatter.string(from: self)
    }
}
