//
//  ChooseLocationViewController.swift
//  DevFriends
//
//  Created by 이대현 on 2022/11/24.
//

import Combine
import MapKit
import SnapKit
import UIKit

final class ChooseLocationViewController: DefaultViewController {
    private lazy var chooseLocationLabel: UILabel = {
        let label = UILabel()
        label.text = "모각코할 장소를 선택해주세요."
        return label
    }()
    
    private lazy var mapView: MKMapView = {
        let mapView = MKMapView(frame: .zero)
        mapView.delegate = self
        mapView.showsUserLocation = true
        return mapView
    }()
    
    private lazy var submitButton: CommonButton = {
        let button = CommonButton(text: "작성 완료")
        return button
    }()
    
    override func configureUI() {
        view.backgroundColor = .white
    }
    
    override func layout() {
        view.addSubview(chooseLocationLabel)
        chooseLocationLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.left.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.right.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
        
        view.addSubview(mapView)
        mapView.snp.makeConstraints { make in
            make.top.equalTo(chooseLocationLabel.snp.bottom).offset(20)
            make.left.right.equalTo(chooseLocationLabel)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-100)
        }
        
        view.addSubview(submitButton)
        submitButton.snp.makeConstraints { make in
            make.top.equalTo(mapView.snp.bottom).offset(20)
            make.left.right.equalTo(mapView)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
    }
}

// MARK: MapView, Location Delegate Methods
extension ChooseLocationViewController: CLLocationManagerDelegate, MKMapViewDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        if let location = locations.last {
//            manager.stopUpdatingLocation()
//            let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude,
//                                                    longitude: location.coordinate.longitude)
//            let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
//            let region = MKCoordinateRegion(center: coordinate, span: span)
//            mogakcoMapView.setRegion(region, animated: false)
//            let location = Location(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
//            viewModel.fetchMogakco(location: location, distance: mapViewDistance())
//        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
//        if let annotation = view.annotation {
//            let latitude = annotation.coordinate.latitude
//            let longitude = annotation.coordinate.longitude
//            moveLocation(latitudeValue: latitude, longtudeValue: longitude, delta: 0.01)
//            showMogakcoCollectionView()
//            let location = Location(latitude: latitude, longitude: longitude)
//            viewModel.fetchMogakco(location: location, distance: mapViewDistance())
//        }
    }
    func mapViewWillStartLoadingMap(_ mapView: MKMapView) {
//        if isFirstLoadingMap {
//            setUserLocation()
//            isFirstLoadingMap = false
//        }
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
//        hideMogakcoCollectionView()
    }
}
