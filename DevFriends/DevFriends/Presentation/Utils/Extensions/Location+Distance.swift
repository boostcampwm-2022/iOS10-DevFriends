//
//  Location+Distance.swift
//  DevFriends
//
//  Created by 이대현 on 2022/12/03.
//

import CoreLocation

extension Location {
    func distance(from: Location) -> Double {
        let fromCLLocation = CLLocation(latitude: from.latitude, longitude: from.longitude)
        let toCLLocation = CLLocation(latitude: self.latitude, longitude: self.longitude)
        return fromCLLocation.distance(from: toCLLocation)
    }
}
