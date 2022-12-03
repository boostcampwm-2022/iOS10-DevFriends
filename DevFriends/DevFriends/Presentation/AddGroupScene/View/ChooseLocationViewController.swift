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

struct ChooseLocationViewActions {
    let didSubmitLocation: (Location) -> Void
}

final class ChooseLocationViewController: UIViewController {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "모각코할 장소를 선택해주세요."
        label.font = UIFont.boldSystemFont(ofSize: 24)
        return label
    }()
    
    private lazy var mapView: MKMapView = {
        let mapView = MKMapView(frame: .zero)
        mapView.delegate = self
        return mapView
    }()
    
    private let currentLocationButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(systemName: "scope")
        configuration.baseForegroundColor = .black
        configuration.contentInsets = NSDirectionalEdgeInsets.init(top: 10, leading: 10, bottom: 10, trailing: 10)
        let button = UIButton(configuration: configuration, primaryAction: nil)
        button.backgroundColor = .white
        button.layer.cornerRadius = 25
        button.layer.cornerCurve = .circular
        button.layer.shadowColor = UIColor.gray.cgColor
        button.layer.shadowOpacity = 1.0
        button.layer.shadowOffset = CGSize.zero
        button.layer.shadowRadius = 6
        return button
    }()
    
    private let locationPin: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "mappin.and.ellipse")
        imageView.tintColor = UIColor(red: 0.992, green: 0.577, blue: 0.277, alpha: 1)
        return imageView
    }()
    
    private let infomationLabel: UILabel = {
        let padding = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        let label = CommonPaddingLabel(padding: padding)
        label.backgroundColor = .black
        label.textColor = .white
        label.text = "지도를 움직여서 선택해보세요."
        label.clipsToBounds = true // cornerRadius 전에 해줘야 합니다
        label.layer.cornerRadius = 10
        return label
    }()
    
    private let submitButton: CommonButton = {
        let button = CommonButton(text: "작성 완료")
        return button
    }()
    
    private lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        return locationManager
    }()
    
    private var isFirstLoadingMap = true
    private var isFirstMovingMap = true
    
    private var centerLocation: Location {
        return Location(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
    }
    
    var cancellables = Set<AnyCancellable>()

    private let actions: ChooseLocationViewActions

    init(actions: ChooseLocationViewActions) {
        self.actions = actions
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        self.layout()
        self.bind()
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        self.setupTapGesture()
    }
    
    private func setupTapGesture() {
        let tapGestureRecognizer = UITapGestureRecognizer()
        tapGestureRecognizer.delegate = self
        self.mapView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func bind() {
        currentLocationButton.publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                self?.setUserLocation()
            }
            .store(in: &cancellables)
        submitButton.publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                if let location = self?.centerLocation {
                    self?.actions.didSubmitLocation(location)
                }
            }
            .store(in: &cancellables)
    }
    
    private func layout() {
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.left.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.right.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
        
        view.addSubview(mapView)
        mapView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        view.addSubview(locationPin)
        locationPin.snp.makeConstraints { make in
            make.centerX.equalTo(mapView)
            make.bottom.equalTo(mapView.snp.centerY)
            make.width.equalTo(50)
            make.height.equalTo(50)
        }
        
        view.addSubview(infomationLabel)
        infomationLabel.snp.makeConstraints { make in
            make.centerX.equalTo(locationPin)
            make.bottom.equalTo(locationPin.snp.top).offset(-20)
        }
        
        view.addSubview(submitButton)
        submitButton.snp.makeConstraints { make in
            make.left.right.equalTo(titleLabel)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.height.equalTo(50)
        }
        
        view.addSubview(currentLocationButton)
        currentLocationButton.snp.makeConstraints { make in
            make.trailing.equalTo(submitButton)
            make.bottom.equalTo(submitButton.snp.top).offset(-20)
            make.width.height.equalTo(50)
        }
    }
}

// MARK: MapView, Location Delegate Methods
extension ChooseLocationViewController: CLLocationManagerDelegate, MKMapViewDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            manager.stopUpdatingLocation()
            let coordinate = CLLocationCoordinate2D(
                latitude: location.coordinate.latitude,
                longitude: location.coordinate.longitude)
            let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            let region = MKCoordinateRegion(center: coordinate, span: span)
            mapView.setRegion(region, animated: false)
        }
    }
    
    func mapViewWillStartLoadingMap(_ mapView: MKMapView) {
        if isFirstLoadingMap {
            setUserLocation()
            isFirstLoadingMap = false
        }
    }
    
    func setUserLocation() {
        print(mapView.centerCoordinate)
        // TODO: 뭔가 애니메이션 효과가 있으면 좋을 듯
        locationManager.startUpdatingLocation()
    }
}

extension ChooseLocationViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if !self.infomationLabel.isHidden {
            self.infomationLabel.isHidden = true
        }
        return true
    }
}
