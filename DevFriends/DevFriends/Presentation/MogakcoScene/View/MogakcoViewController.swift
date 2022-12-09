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

final class MogakcoViewController: UIViewController {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "모각코"
        label.font = .systemFont(ofSize: 25, weight: .bold)
        return label
    }()
    
    private lazy var groupAddButton: UIBarButtonItem = {
        let item = UIBarButtonItem()
        item.image = .plus
        item.tintColor = .devFriendsBase
        item.target = self
        item.action = #selector(didTapMogakcoAddButton)
        return item
    }()
    
    private lazy var notificationButton: UIBarButtonItem = {
        let item = UIBarButtonItem()
        item.image = .bell
        item.tintColor = .devFriendsBase
        item.target = self
        item.action = #selector(didTapNotificationButton)
        return item
    }()
    
    private lazy var mogakcoMapView: MKMapView = {
        let mapView = MKMapView(frame: .zero)
        mapView.delegate = self
        mapView.showsUserLocation = true
        return mapView
    }()
    
    private let currentLocationButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.image = .scope
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
    
    private let viewModeButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.image = .viewMode
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
    
    private let searchOnCurrentLocationButton: UIButton = {
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
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.register(cellType: GroupCollectionViewCell.self)
        return collectionView
    }()
    
    private lazy var mogakcoCollectionViewDiffableDataSource = UICollectionViewDiffableDataSource<Section, Group>(collectionView: mogakcoCollectionView) { collectionView, indexPath, data in
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: GroupCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as? GroupCollectionViewCell else { return UICollectionViewCell() }
        
        cell.set(data)
        return cell
    }
    
    private var mogakcoCollectionViewSnapShot = NSDiffableDataSourceSnapshot<Section, Group>()
    
    private var nowCollectionViewCellIndex = 0
    
    private var isFirstLoadingMap = true
        
    private lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        return locationManager
    }()
    
    private var cancellables = Set<AnyCancellable>()
    
    private let viewModel: MogakcoViewModel
    
    init(viewModel: MogakcoViewModel) {
        self.viewModel = viewModel
        viewModel.fetchAllMogakco()
        
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
    
    private func configureUI() {
        self.setupNavigation()
        self.setupCollection()
    }
    
    private func layout() {
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
    
    private func bind() {
        viewModeButton.publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                self?.deselectAllAnnotations()
                self?.viewModel.didSelectViewModeButton()
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
    
    private func setupNavigation() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
        self.navigationItem.rightBarButtonItems = [notificationButton, groupAddButton]
    }
    
    private func setupCollection() {
        mogakcoCollectionView.collectionViewLayout = UICollectionViewCompositionalLayout { sectionNumber, _ -> NSCollectionLayoutSection? in
            
            let item = NSCollectionLayoutItem(
                layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
            )
            item.contentInsets.trailing = 5
            
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: .init(widthDimension: .absolute(UIScreen.main.bounds.size.width - 30), heightDimension: .absolute(140)),
                subitems: [item]
            )
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .groupPaging
            section.contentInsets.leading = 10
            section.contentInsets.trailing = 10
            section.contentInsets.top = 5
            section.contentInsets.bottom = 5
            
            // SH: 기존 scrollViewWillEndDragging에서 하던 작업 아래 클로저에서 하면 됩니다
            section.visibleItemsInvalidationHandler = { [weak self] _, contentOffset, environment in
                let itemIndex = Int(max(0, round(contentOffset.x / environment.container.contentSize.width)))
                self?.viewModel.nowMogakco(index: itemIndex)
            }
            
            return section
        }
    }
    
    private func moveMogakcoLocation(group: Group) {
        moveLocation(latitudeValue: group.location.latitude, longtudeValue: group.location.longitude, delta: 0.01)
    }
    
    private func setMogakcoPin(groups: [Group]) {
        for group in groups {
            setAnnotation(
                latitudeValue: group.location.latitude,
                longitudeValue: group.location.longitude,
                delta: 0.1,
                title: group.title
            )
        }
    }
    
    private func searchOnCurrentLocation() {
        let currentLocation = mogakcoMapView.region.center
        let location = Location(latitude: currentLocation.latitude, longitude: currentLocation.longitude)
        viewModel.fetchMogakco(location: location, distance: mapViewDistance())
        mogakcoMapView.removeAnnotations(mogakcoMapView.annotations)
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
    
    func mapViewDistance() -> Double {
        let span = mogakcoMapView.region.span
        let center = mogakcoMapView.region.center
        let centerLocation = CLLocation(latitude: center.latitude, longitude: center.longitude)
        let destination = CLLocation(
            latitude: center.latitude + span.latitudeDelta * 0.5,
            longitude: center.longitude + span.longitudeDelta * 0.5
        )
        return destination.distance(from: centerLocation)
    }
    
    func setUserLocation() {
        locationManager.startUpdatingLocation()
        mogakcoMapView.removeAnnotations(mogakcoMapView.annotations)
    }
    
    func setNowMogakcoWithAllList(index: Int) {
        viewModel.nowMogakcoWithAllList(index: index, distance: mapViewDistance())
    }
}

// MARK: MapView, Location Delegate Methods
extension MogakcoViewController: CLLocationManagerDelegate, MKMapViewDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            manager.stopUpdatingLocation()
            let coordinate = CLLocationCoordinate2D(
                latitude: location.coordinate.latitude,
                longitude: location.coordinate.longitude
            )
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

extension MogakcoViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.didSelectNowMogakco()
    }
}

// MARK: - Actions

extension MogakcoViewController {
    @objc func didTapMogakcoAddButton(_ sender: UIButton) {
        viewModel.didSelectAddMogakco()
    }
    
    @objc func didTapNotificationButton(_ sender: UIButton) {
        viewModel.didSelectNotifications()
    }
}
