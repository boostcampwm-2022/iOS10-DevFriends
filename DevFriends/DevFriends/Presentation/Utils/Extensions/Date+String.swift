//
//  Date+String.swift
//  DevFriends
//
//  Created by 심주미 on 2022/11/15.
//

import Foundation

extension Date {
    func toTimeString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: self)
    }
}