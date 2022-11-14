//
//  MogakcoViewController.swift
//  DevFriends
//
//  Created by 이대현 on 2022/11/14.
//

import UIKit
import SnapKit
import MapKit

class MogakcoViewController: UIViewController {
    
    lazy var mogakcoMapView: MKMapView = {
        let mogakcoMap = MKMapView(frame: .zero)
        return mogakcoMap
    }()
    
    // 현재 위치를 불러오는 작업은 뷰컨에서 하면 안될 것 같긴 한데
    // 일단 테스트
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        layout()
        setUserLocation()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: Map Init Methods
extension MogakcoViewController {
    func setUserLocation() {
//        mogakcoMapView.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        mogakcoMapView.showsUserLocation = true
    }
}

// MARK: Location Delegate Methods
extension MogakcoViewController: CLLocationManagerDelegate, MKMapViewDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            manager.stopUpdatingLocation()
            render(location)
        }
        //        let location = locations.last
        //
        //        // 위치정보 반환
        //        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        //
        //        // MKCoordinateSpan -- 지도 scale
        //        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta:0.01, longitudeDelta:0.01))
        //
        //        self.mogakcoMapView.setRegion(region, animated: true)
        //        self.locationManager.stopUpdatingLocation()
    }
    func render(_ location: CLLocation) {
        let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mogakcoMapView.setRegion(region, animated: true)
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Errors: " + error.localizedDescription)
    }
}

// MARK: UI Layout Methods
extension MogakcoViewController {
    private func layout() {
        view.addSubview(mogakcoMapView)
        mogakcoMapView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
