//
//  MogakcoViewController.swift
//  DevFriends
//
//  Created by 이대현 on 2022/11/14.
//

import Combine
import UIKit
import SnapKit
import MapKit

final class MogakcoViewController: DefaultViewController {
    private lazy var mogakcoMapView: MKMapView = {
        let mapView = MKMapView(frame: .zero)
        mapView.delegate = self
        mapView.showsUserLocation = true
        return mapView
    }()
    
    private lazy var currentLocationButton: UIButton = {
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
    
    private lazy var viewModeButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(systemName: "line.3.horizontal")
        configuration.baseForegroundColor = .black
        configuration.imagePlacement = .leading
        configuration.imagePadding = 5
        configuration.title = "목록보기"
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        let button = UIButton(configuration: configuration, primaryAction: nil)
        button.backgroundColor = .white
        button.layer.cornerRadius = 25
        button.layer.cornerCurve = .circular
        button.layer.shadowColor = UIColor.gray.cgColor
        button.layer.shadowOpacity = 1.0
        button.layer.shadowOffset = CGSize.zero
        button.layer.shadowRadius = 3
        return button
    }()
    
    private lazy var mogakcoSubView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: UIScreen.main.bounds.size.width * 0.9, height: 140.0)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(GroupCollectionViewCell.self,
                                forCellWithReuseIdentifier: GroupCollectionViewCell.reuseIdentifier)
        return collectionView
    }()
    
    private lazy var mogakcoCollectionViewDiffableDataSource = UICollectionViewDiffableDataSource<Section, Group>(collectionView: mogakcoSubView) { collectionView, indexPath, data in
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GroupCollectionViewCell.reuseIdentifier,
                                                            for: indexPath) as? GroupCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.set(data)
        return cell
    }
    
    private var mogakcoCollectionViewSnapShot = NSDiffableDataSourceSnapshot<Section, Group>()
   
    private var isSelectingPin = false
    
    private lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        return locationManager
    }()
    
    private let viewModel = MogakcoViewModel(fetchGroupUseCase: DefaultFetchGroupUseCase(groupRepository: DefaultGroupRepository()))
    private let input = PassthroughSubject<MogakcoViewModel.Input, Never>()
    
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
    
    override func configureUI() {
        setUserLocation()
    }
    
    override func layout() {
        view.addSubview(mogakcoMapView)
        mogakcoMapView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        view.addSubview(mogakcoSubView)
        mogakcoSubView.snp.makeConstraints { make in
            make.bottom.equalTo(mogakcoMapView)
            make.leading.equalTo(mogakcoMapView).offset(20)
            make.trailing.equalTo(-20)
            make.height.equalTo(0) // 처음에 높이 0으로 설정, 나중에 SubView를 띄울 때 설정
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
    
    override func bind() {
        viewModeButton.publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                self?.deselectAllAnnotations()
                self?.hideMogakcoSubView()
                self?.showMogakcoModal()
            }
            .store(in: &cancellables)
        
        currentLocationButton.publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                self?.setUserLocation()
            }
            .store(in: &cancellables)
        viewModel.transform(input: input.eraseToAnyPublisher())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                switch event {
                case .allMogakcos(groups: let groups): break
                    //self?.setMogakcoPin(groups: groups)
                case .mogakcos(groups: let groups):
                    self?.populateSnapshot(data: groups)
                    self?.setMogakcoPin(groups: groups)
                }
            }
            .store(in: &cancellables)
    }
    
    private func setMogakcoPin(groups: [Group]) {
        for group in groups {
            setAnnotation(
                latitudeValue: group.location.latitude,
                longitudeValue: group.location.longitude,
                delta: 0.1,
                title: group.title,
                subtitle: "위치 이름")
        }
    }
    
    private func populateSnapshot(data: [Group]) {
        mogakcoCollectionViewSnapShot.deleteAllItems()
        mogakcoCollectionViewSnapShot.appendSections([.main])
        mogakcoCollectionViewSnapShot.appendItems(data)
        mogakcoCollectionViewDiffableDataSource.apply(mogakcoCollectionViewSnapShot)
    }
    
    func showMogakcoSubView() {
        mogakcoSubView.snp.updateConstraints { make in
            make.height.equalTo(150)
        }
    }
    
    func hideMogakcoSubView() {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut) {
            self.mogakcoSubView.snp.updateConstraints { make in
                make.height.equalTo(0)
            }
        }
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

// MARK: Map Init Methods
extension MogakcoViewController {
    func setUserLocation() {
        locationManager.startUpdatingLocation()
        mogakcoMapView.removeAnnotations(mogakcoMapView.annotations)
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
        let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude,
                                                longitude: location.coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mogakcoMapView.setRegion(region, animated: true)
        input.send(.fetchMogakco(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude))
    }
    
    private func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Errors: " + error.localizedDescription)
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation {
            let latitude = annotation.coordinate.latitude
            let longitude = annotation.coordinate.longitude
            isSelectingPin = true
            moveLocation(latitudeValue: latitude, longtudeValue: longitude, delta: 0.01)
            showMogakcoSubView()
            input.send(.fetchMogakco(latitude: latitude, longitude: longitude))
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
