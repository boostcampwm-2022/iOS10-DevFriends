//
//  CLLocation+Distance.swift
//  DevFriends
//
//  Created by 심주미 on 2022/11/19.
//

import CoreLocation

extension CLLocation {
    class func distance(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> CLLocationDistance {
        let from = CLLocation(latitude: from.latitude, longitude: from.longitude)
        let to = CLLocation(latitude: to.latitude, longitude: to.longitude)
        return from.distance(from: to)
    }
}
