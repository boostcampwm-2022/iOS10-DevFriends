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
    
    lazy var mogakcoSubView: UIView = {
        let mogakcoSubView = UIView()
        mogakcoSubView.backgroundColor = .green
        mogakcoSubView.isHidden = true
        return mogakcoSubView
    }()
    lazy var showButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("show", for: .normal)
        btn.backgroundColor = .green
        btn.addTarget(self, action: #selector(showCollections), for: .touchUpInside)
        return btn
    }()
    lazy var hideButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("hide", for: .normal)
        btn.backgroundColor = .green
        btn.addTarget(self, action: #selector(hideCollections), for: .touchUpInside)
        return btn
    }()
    lazy var modalButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("modal", for: .normal)
        btn.backgroundColor = .green
        btn.addTarget(self, action: #selector(showModal), for: .touchUpInside)
        return btn
    }()
    @objc func showCollections() {
        // TODO: Test
        showMogakcoSubView()
    }
    @objc func hideCollections() {
        // TODO: Test
        hideMogakcoSubView()
    }
    @objc func showModal() {
        // TODO: Test
        showMogakcoModal()
    }
    
    var isSelectingPin = false
    
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
        setUserLocation()
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
    
    private func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Errors: " + error.localizedDescription)
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("you tapped the pin!")
        if let annotation = view.annotation {
            let latitudeVal = annotation.coordinate.latitude
            let longtitudeVal = annotation.coordinate.longitude
            isSelectingPin = true
            moveLocation(latitudeValue: latitudeVal, longtudeValue: longtitudeVal, delta: 0.01)
            showMogakcoSubView()
        }
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        hideMogakcoSubView()
    }
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        // pin을 선택할 때 아래에서 Deselect되는 것을 방지
        if isSelectingPin {
            isSelectingPin = false
            return
        }
        for annotation in mapView.annotations {
            mapView.deselectAnnotation(annotation, animated: true)
        }
        hideMogakcoSubView()
    }
}

// MARK: UI Layout Methods
extension MogakcoViewController {
    private func layout() {
        view.addSubview(mogakcoMapView)
        mogakcoMapView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        view.addSubview(mogakcoSubView)
        mogakcoSubView.snp.makeConstraints { make in
            make.top.equalTo(mogakcoMapView.snp.bottom)
            make.leading.equalTo(mogakcoMapView).offset(20)
            make.trailing.equalTo(-20)
            make.height.equalTo(100)
        }
        
        view.addSubview(currentLocationButton)
        currentLocationButton.snp.makeConstraints { make in
            make.leading.equalTo(mogakcoSubView).offset(20)
            make.bottom.equalTo(mogakcoSubView.snp.top).offset(-20)
            make.width.height.equalTo(50)
        }
        
        view.addSubview(viewModeButton)
        viewModeButton.snp.makeConstraints { make in
            make.trailing.equalTo(mogakcoSubView).offset(-20)
            make.bottom.equalTo(mogakcoSubView.snp.top).offset(-20)
            make.height.equalTo(50)
            make.width.equalTo(120)
        }
        
        view.addSubview(showButton)
        showButton.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(50)
        }
        view.addSubview(hideButton)
        hideButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(50)
            make.top.equalToSuperview().offset(90)
        }
        view.addSubview(modalButton)
        modalButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(50)
            make.top.equalToSuperview().offset(130)
        }
    }
    
    func showMogakcoSubView() {
        // 현재위치버튼, 뷰모드 버튼 레이아웃 변경
        mogakcoSubView.isHidden = false
        mogakcoSubView.snp.remakeConstraints { make in
            make.bottom.equalTo(mogakcoMapView).offset(-20)
            make.leading.equalTo(mogakcoMapView).offset(20)
            make.trailing.equalTo(-20)
            make.height.equalTo(100)
        }
    }
    
    func hideMogakcoSubView() {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut) {
            self.mogakcoSubView.snp.remakeConstraints { make in
                make.top.equalTo(self.mogakcoMapView.snp.bottom)
                make.leading.equalTo(self.mogakcoMapView).offset(20)
                make.trailing.equalTo(-20)
                make.height.equalTo(100)
            }
            self.mogakcoSubView.superview?.layoutIfNeeded()
        }
        mogakcoSubView.isHidden = true
    }
    
    func showMogakcoModal() {
        let mogakcoModal = UIViewController()
        mogakcoModal.view.backgroundColor = .systemYellow
        mogakcoModal.modalPresentationStyle = .pageSheet
        if let sheet = mogakcoModal.sheetPresentationController {
            // 지원할 크기 지정
            sheet.detents = [.medium()]
            // 시트 상단에 그래버 표시 (기본 값은 false)
            sheet.prefersGrabberVisible = true
            // 뒤 배경 흐리게 제거 (기본 값은 모든 크기에서 배경 흐리게 됨)
            sheet.largestUndimmedDetentIdentifier = .medium
        }
        present(mogakcoModal, animated: true, completion: nil)
        view.bringSubviewToFront(viewModeButton)
    }
}
