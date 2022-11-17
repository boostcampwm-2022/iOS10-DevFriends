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
    
    lazy var mogakcoSubView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: UIScreen.main.bounds.size.width * 0.9, height: 140.0)
        
        let mogakcoSubView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        mogakcoSubView.backgroundColor = .clear
        mogakcoSubView.showsHorizontalScrollIndicator = false
        mogakcoSubView.dataSource = self
        mogakcoSubView.register(GroupCollectionViewCell.self, forCellWithReuseIdentifier: GroupCollectionViewCell.reuseIdentifier)
        mogakcoSubView.isHidden = true
        return mogakcoSubView
    }()
   
    var isSelectingPin = false
    
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
        deselectAllAnnotations()
        hideMogakcoSubView()
        showMogakcoModal()
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
    
    private func deselectAllAnnotations() {
        for annotation in mogakcoMapView.annotations {
            mogakcoMapView.deselectAnnotation(annotation, animated: true)
        }
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
    
    // 맵이 이동할 때 호출
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        // Pin을 터치해서 선택하는 과정에서 맵에 Pin을 중심으로 이동하게 되는데,
        // 그 과정에서 아래에서 Pin이 Deselect되는 것을 방지
        if isSelectingPin {
            isSelectingPin = false
            return
        }
        deselectAllAnnotations()
        hideMogakcoSubView()
    }
}

// MARK: CollectionView Delegate Methods
extension MogakcoViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: GroupCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as? GroupCollectionViewCell else { return UICollectionViewCell() }
        
        return cell
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
    }
    
    func showMogakcoSubView() {
        mogakcoSubView.isHidden = false
//        mogakcoSubView.snp.updateConstraints { make in
//            make.bottom.equalTo(mogakcoMapView).offset(-20)
//        }
        mogakcoSubView.snp.remakeConstraints { make in
            make.bottom.equalTo(mogakcoMapView).offset(-20)
            make.leading.equalTo(mogakcoMapView)
            make.trailing.equalTo(mogakcoMapView)
            make.height.equalTo(150)
        }
    }
    
    func hideMogakcoSubView() {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut) {
            self.mogakcoSubView.snp.remakeConstraints { make in
                make.top.equalTo(self.mogakcoMapView.snp.bottom)
                make.leading.equalTo(self.mogakcoMapView)
                make.trailing.equalTo(self.mogakcoMapView)
                make.height.equalTo(180)
            }
            self.mogakcoSubView.superview?.layoutIfNeeded()
        }
        mogakcoSubView.isHidden = true
    }
    
    func showMogakcoModal() {
        let mogakcoModal = MogakcoModalViewController()
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
    }
}
