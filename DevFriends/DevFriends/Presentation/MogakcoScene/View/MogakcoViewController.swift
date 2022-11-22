//
//  MogakcoViewController.swift
//  DevFriends
//
//  Created by 이대현 on 2022/11/14.
//

import Combine
import MapKit
import SnapKit
import UIKit

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
    
    private lazy var searchOnCurrentLocationButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.title = "현 지도에서 검색"
        configuration.baseForegroundColor = .orange
        let button = UIButton(configuration: configuration)
        button.backgroundColor = .white
        button.layer.cornerRadius = 15
        return button
    }()
    
    private lazy var mogakcoCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: UIScreen.main.bounds.size.width - 30, height: 140.0)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.register(GroupCollectionViewCell.self,
                                forCellWithReuseIdentifier: GroupCollectionViewCell.reuseIdentifier)
        return collectionView
    }()
    
    private lazy var mogakcoCollectionViewDiffableDataSource = UICollectionViewDiffableDataSource<Section, Group>(collectionView: mogakcoCollectionView) { collectionView, indexPath, data in
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GroupCollectionViewCell.reuseIdentifier,
                                                            for: indexPath) as? GroupCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.set(data)
        return cell
    }
    
    private var mogakcoCollectionViewSnapShot = NSDiffableDataSourceSnapshot<Section, Group>()
    
    private var nowCollectionViewCellIndex = 0
    
    private var isFirstLoadingMap = true
    
    lazy var mogakcoModalViewController: MogakcoModalViewController = {
        let mogakcoModelViewController = MogakcoModalViewController()
        mogakcoModelViewController.delegate = self
        return mogakcoModelViewController
    }()
    
    private lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        return locationManager
    }()
    
    private let viewModel = MogakcoViewModel(fetchGroupUseCase: DefaultFetchGroupUseCase(groupRepository: DefaultGroupRepository()))
    
    // MARK: Set Annotation Methods
    private func moveLocation(latitudeValue: CLLocationDegrees, longtudeValue: CLLocationDegrees, delta span: Double) {
        let pLocation = CLLocationCoordinate2DMake(latitudeValue, longtudeValue)
        let pSpanValue = MKCoordinateSpan(latitudeDelta: span, longitudeDelta: span)
        let pRegion = MKCoordinateRegion(center: pLocation, span: pSpanValue)
        mogakcoMapView.setRegion(pRegion, animated: true)
    }
    
    private func setAnnotation(latitudeValue: CLLocationDegrees, longitudeValue: CLLocationDegrees, delta span: Double, title strTitle: String) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2DMake(latitudeValue, longitudeValue)
        annotation.title = strTitle
        mogakcoMapView.addAnnotation(annotation)
    }
    
    private func deselectAllAnnotations() {
        for annotation in mogakcoMapView.annotations {
            mogakcoMapView.deselectAnnotation(annotation, animated: true)
        }
    }
    
    override func layout() {
        view.addSubview(mogakcoMapView)
        mogakcoMapView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        view.addSubview(mogakcoCollectionView)
        mogakcoCollectionView.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalTo(mogakcoMapView)
            make.height.equalTo(0) // 처음에 높이 0으로 설정, 나중에 SubView를 띄울 때 설정
        }
        
        view.addSubview(currentLocationButton)
        currentLocationButton.snp.makeConstraints { make in
            make.leading.equalTo(mogakcoCollectionView).offset(20)
            make.bottom.equalTo(mogakcoCollectionView.snp.top).offset(-20)
            make.width.height.equalTo(50)
        }
        
        view.addSubview(viewModeButton)
        viewModeButton.snp.makeConstraints { make in
            make.trailing.equalTo(mogakcoCollectionView).offset(-20)
            make.bottom.equalTo(mogakcoCollectionView.snp.top).offset(-20)
            make.height.equalTo(50)
            make.width.equalTo(120)
        }
        
        view.addSubview(searchOnCurrentLocationButton)
        searchOnCurrentLocationButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
    }
    
    override func bind() {
        viewModeButton.publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                self?.deselectAllAnnotations()
                self?.showMogakcoModal()
            }
            .store(in: &cancellables)
        
        currentLocationButton.publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                self?.setUserLocation()
            }
            .store(in: &cancellables)
        
        searchOnCurrentLocationButton.publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                self?.searchOnCurrentLocation()
            }
            .store(in: &cancellables)
        
        viewModel.allMogakcosSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] groups in
                self?.deselectAllAnnotations()
                self?.setMogakcoPin(groups: groups)
                self?.mogakcoModalViewController.populateSnapshot(data: groups)
            }
            .store(in: &cancellables)
        
        viewModel.mogakcosSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] groups in
                self?.populateSnapshot(data: groups)
                self?.setMogakcoPin(groups: groups)
            }
            .store(in: &cancellables)
        
        viewModel.nowMogakcoSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] group in
                self?.moveMogakcoLocation(group: group)
            }
            .store(in: &cancellables)
    }
    
    private func moveMogakcoLocation(group: Group) {
        moveLocation(latitudeValue: group.location.latitude, longtudeValue: group.location.longitude, delta: 0.01)
    }
    
    private func setMogakcoPin(groups: [Group]) {
        mogakcoMapView.removeAnnotations(mogakcoMapView.annotations)
        for group in groups {
            setAnnotation(
                latitudeValue: group.location.latitude,
                longitudeValue: group.location.longitude,
                delta: 0.1,
                title: group.title)
        }
    }
    
    private func searchOnCurrentLocation() {
        let currentLocation = mogakcoMapView.region.center
        let location = Location(latitude: currentLocation.latitude, longitude: currentLocation.longitude)
        viewModel.fetchMogakco(location: location, distance: mapViewDistance())
    }
    
    private func populateSnapshot(data: [Group]) {
        mogakcoCollectionViewSnapShot.deleteAllItems()
        mogakcoCollectionViewSnapShot.appendSections([.main])
        mogakcoCollectionViewSnapShot.appendItems(data)
        mogakcoCollectionViewDiffableDataSource.apply(mogakcoCollectionViewSnapShot)
    }
    
    func showMogakcoCollectionView() {
        self.mogakcoCollectionView.snp.updateConstraints { make in
            make.height.equalTo(150)
        }
    }
    
    func hideMogakcoCollectionView() {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut) {
            self.mogakcoCollectionView.snp.updateConstraints { make in
                make.height.equalTo(0)
            }
        }
    }
    
    func showMogakcoModal() {
        
        mogakcoModalViewController.modalPresentationStyle = .pageSheet
        if let sheet = mogakcoModalViewController.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
            sheet.largestUndimmedDetentIdentifier = .medium
        }
        present(mogakcoModalViewController, animated: true, completion: nil)
        viewModel.fetchAllMogakco()
    }
    
    func mapViewDistance() -> Double {
        let span = mogakcoMapView.region.span
        let center = mogakcoMapView.region.center
        let centerLocation = CLLocation(latitude: center.latitude, longitude: center.longitude)
        let to = CLLocation(latitude: center.latitude + span.latitudeDelta * 0.5, longitude: center.longitude + span.longitudeDelta * 0.5)
        return to.distance(from: centerLocation)
    }
}

// MARK: Map Init Methods
extension MogakcoViewController {
    func setUserLocation() {
        locationManager.startUpdatingLocation()
    }
}

// MARK: MapView, Location Delegate Methods
extension MogakcoViewController: CLLocationManagerDelegate, MKMapViewDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            manager.stopUpdatingLocation()
            let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude,
                                                    longitude: location.coordinate.longitude)
            let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            let region = MKCoordinateRegion(center: coordinate, span: span)
            mogakcoMapView.setRegion(region, animated: false)
            let location = Location(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            viewModel.fetchMogakco(location: location, distance: mapViewDistance())
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation {
            let latitude = annotation.coordinate.latitude
            let longitude = annotation.coordinate.longitude
            moveLocation(latitudeValue: latitude, longtudeValue: longitude, delta: 0.01)
            showMogakcoCollectionView()
            let location = Location(latitude: latitude, longitude: longitude)
            viewModel.fetchMogakco(location: location, distance: mapViewDistance())
        }
    }
    func mapViewWillStartLoadingMap(_ mapView: MKMapView) {
        if isFirstLoadingMap {
            setUserLocation()
            isFirstLoadingMap = false
        }
        
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        hideMogakcoCollectionView()
    }
}

extension MogakcoViewController: MogakcoModalViewControllerDelegate {
    func tapCell(index: Int) {
        showMogakcoCollectionView()
        viewModel.nowMogakcoWithAllList(index: index, distance: mapViewDistance())
    }
}

extension MogakcoViewController: UICollectionViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let cellWidthIncludingSpacing = view.frame.width - 30
        var offset = targetContentOffset.pointee
        let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
        
        var roundedIndex = round(index)
        if scrollView.contentOffset.x > targetContentOffset.pointee.x {
            roundedIndex = floor(index)
        } else {
            roundedIndex = ceil(index)
        }
        
        offset = CGPoint(x: roundedIndex * cellWidthIncludingSpacing - scrollView.contentInset.left, y: -scrollView.contentInset.top)
        targetContentOffset.pointee = offset
        
        if scrollView.contentOffset.x > targetContentOffset.pointee.x {
            roundedIndex = floor(index)
        } else if scrollView.contentOffset.x < targetContentOffset.pointee.x {
            roundedIndex = ceil(index)
        } else {
            roundedIndex = round(index)
        }
        
        if nowCollectionViewCellIndex > Int(roundedIndex) {
            nowCollectionViewCellIndex -= 1
        } else if nowCollectionViewCellIndex < Int(roundedIndex) {
            nowCollectionViewCellIndex += 1
        }
        viewModel.nowMogakco(index: nowCollectionViewCellIndex)
    }
}
