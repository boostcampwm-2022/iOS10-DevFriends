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
    
    func toKoreanString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY년 MM월 dd일 HH:mm"
        return dateFormatter.string(from: self)
    }

    func isSameTime(as other: Date?) -> Bool {
        guard let other = other else { return false }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        let myDate = dateFormatter.string(from: self)
        let otherDate = dateFormatter.string(from: other)
        
        if myDate == otherDate {
            return true
        }
        
        return false
    }
    
    func isSameDate(as other: Date?) -> Bool {
        guard let other = other else { return false }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYYMMdd"
        
        let myDate = dateFormatter.string(from: self)
        let otherDate = dateFormatter.string(from: other)
        
        if myDate == otherDate {
            return true
        }
        
        return false
    }
    
    func toKoreanStringWithDay() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY년 MM월 dd일 EEEE"
        return dateFormatter.string(from: self)
    }
}
