//
//  FetchGroupCellInfoUseCase.swift
//  DevFriends
//
//  Created by 이대현 on 2022/11/22.
//

import Foundation
import CoreLocation

protocol FetchGroupCellInfoUseCase {
    func execute(groupsData: [Group]) async -> [GroupCellInfo]
}

final class DefaultFecthGroupCellInfoUseCase: FetchGroupCellInfoUseCase {
    func execute(groupsData: [Group]) async -> [GroupCellInfo] {
        var groupCellInfos: [GroupCellInfo] = []
        
        for group in groupsData {
            let placeString = await address(
                location: CLLocation(latitude: group.location.latitude, longitude: group.location.longitude))
            groupCellInfos.append(GroupCellInfo(
                title: group.title,
                categories: group.categories,
                place: placeString ?? "",
                currentPeople: group.limitedNumberPeople /*TODO: 서버에 현재원 없음!*/,
                peopleLimit: group.limitedNumberPeople))
        }
        return groupCellInfos
    }
    
    private func address(location: CLLocation) async -> String? {
        let loadPlaceTask = Task {
            let geocoder = CLGeocoder()
            let locale = Locale(identifier: "Ko-kr")
            return try await geocoder.reverseGeocodeLocation(location, preferredLocale: locale)
        }
        let result = await loadPlaceTask.result
        do {
            let placemarks = try result.get()
            guard let placemark = placemarks.first else { return nil }
            return placemark.thoroughfare
        } catch {
            print("Get address from location Error !!")
            return nil
        }
    }
}
