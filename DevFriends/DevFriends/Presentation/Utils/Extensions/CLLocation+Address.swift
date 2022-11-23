//
//  CLLocation+Address.swift
//  DevFriends
//
//  Created by 심주미 on 2022/11/22.
//

import CoreLocation

extension CLLocation {
    
    func placemark() async throws -> String? {
        let geocoder = CLGeocoder()
        let locale = Locale(identifier: "Ko-kr")
        return try await geocoder.reverseGeocodeLocation(self, preferredLocale: locale).first?.name
    }
}
