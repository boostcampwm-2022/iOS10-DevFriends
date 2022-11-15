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
        let mogakcoMapView = MKMapView(frame: .zero)
        return mogakcoMapView
    }()
    
    lazy var currentLocationButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(systemName: "scope")
        configuration.baseForegroundColor = .black
        configuration.contentInsets = NSDirectionalEdgeInsets.init(top: 10, leading: 10, bottom: 10, trailing: 10)
        let currentLocationButton = UIButton(configuration: configuration, primaryAction: nil)
        currentLocationButton.backgroundColor = .white
        currentLocationButton.layer.cornerRadius = 25
        currentLocationButton.layer.cornerCurve = .circular
        currentLocationButton.layer.shadowColor = UIColor.gray.cgColor
        currentLocationButton.layer.shadowOpacity = 1.0
        currentLocationButton.layer.shadowOffset = CGSize.zero
        currentLocationButton.layer.shadowRadius = 6
        currentLocationButton.addTarget(self, action: #selector(didTapCurrentButton), for: .touchUpInside)
        return currentLocationButton
    }()
    
    lazy var viewModeButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(systemName: "line.3.horizontal")
        configuration.baseForegroundColor = .black
        configuration.imagePlacement = .leading
        configuration.imagePadding = 5
        configuration.title = "목록보기"
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        let viewModeButton = UIButton(configuration: configuration, primaryAction: nil)
        viewModeButton.backgroundColor = .white
        viewModeButton.layer.cornerRadius = 25
        viewModeButton.layer.cornerCurve = .circular
        viewModeButton.layer.shadowColor = UIColor.gray.cgColor
        viewModeButton.layer.shadowOpacity = 1.0
        viewModeButton.layer.shadowOffset = CGSize.zero
        viewModeButton.layer.shadowRadius = 3
        viewModeButton.addTarget(self, action: #selector(didTapViewModeButton), for: .touchUpInside)
        return viewModeButton
    }()
    
    lazy var mogakcoSubView: UIStackView = {
        let mogakcoSubView = UIStackView()
        mogakcoSubView.backgroundColor = .green
        return mogakcoSubView
    }()
    
    // 현재 위치를 불러오는 작업은 뷰컨에서 하면 안될 것 같긴 한데
    // 일단 테스트
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mogakcoMapView.delegate = self
        view.backgroundColor = .white
        layout()
        setUserLocation()
        // 내맘대로 핀 1개 찍기
        moveLocation(latitudeValue: 37.5029, longtudeValue: 127.0279, delta: 0.1)
        setAnnotation(latitudeValue: 37.5029, longitudeValue: 127.0279, delta: 0.1, title: "Combine 공부할 사람 내가 가르쳐줌", subtitle: "강남 에이비카페")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Action Methods
    
    @objc func didTapCurrentButton() {
        print("tap Current Button")
    }
    
    @objc func didTapViewModeButton() {
        print("tap ViewMode Button")
    }
    
    // MARK: Set Annotation Methods
    private func moveLocation(latitudeValue: CLLocationDegrees, longtudeValue: CLLocationDegrees, delta span: Double) {
        let pLocation = CLLocationCoordinate2DMake(latitudeValue, longtudeValue)
        let pSpanValue = MKCoordinateSpan(latitudeDelta: span, longitudeDelta: span)
        let pRegion = MKCoordinateRegion(center: pLocation, span: pSpanValue)
        mogakcoMapView.setRegion(pRegion, animated: true)
    }
    
    private func setAnnotation(latitudeValue: CLLocationDegrees, longitudeValue: CLLocationDegrees, delta span: Double, title strTitle: String, subtitle strSubTitle: String) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2DMake(latitudeValue, longitudeValue)
        annotation.title = strTitle
        annotation.subtitle = strSubTitle
        mogakcoMapView.addAnnotation(annotation)
    }
}

// MARK: Map Init Methods
extension MogakcoViewController {
    func setUserLocation() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        mogakcoMapView.showsUserLocation = true
    }
}

// MARK: MapView, Location Delegate Methods
extension MogakcoViewController: CLLocationManagerDelegate, MKMapViewDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            manager.stopUpdatingLocation()
            render(location)
        }
    }
    
    func render(_ location: CLLocation) {
        let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mogakcoMapView.setRegion(region, animated: true)
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Errors: " + error.localizedDescription)
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("you tapped the pin!")
        moveLocation(latitudeValue: 70.4, longtudeValue: 127.1, delta: 0.01)
        setAnnotation(latitudeValue: 70.4, longitudeValue: 127.1, delta: 0.01, title: "여긴 어디", subtitle: "강남 에이비카페")
    }
}

// MARK: UI Layout Methods
extension MogakcoViewController {
    private func layout() {
        view.addSubview(mogakcoMapView)
        mogakcoMapView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        view.addSubview(currentLocationButton)
        currentLocationButton.snp.makeConstraints { make in
            make.leading.equalTo(mogakcoMapView).offset(20)
            make.bottom.equalTo(mogakcoMapView).offset(-30)
            make.width.height.equalTo(50)
        }
        
        view.addSubview(viewModeButton)
        viewModeButton.snp.makeConstraints { make in
            make.trailing.equalTo(mogakcoMapView).offset(-20)
            make.bottom.equalTo(mogakcoMapView).offset(-30)
            make.height.equalTo(50)
            make.width.equalTo(120)
        }
        
//        view.addSubview(mogakcoSubView)
//        mogakcoSubView.snp.makeConstraints { make in
//            make.bottom.equalTo(mogakcoMapView).offset(-20)
//            make.leading.equalTo(mogakcoMapView).offset(20)
//            make.trailing.equalTo(-20)
//            make.height.equalTo(100)
//        }
    }
}
