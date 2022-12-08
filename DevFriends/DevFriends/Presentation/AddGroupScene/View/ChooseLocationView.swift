//
//  ChooseLocationView.swift
//  DevFriends
//
//  Created by 이대현 on 2022/11/27.
//

import CoreLocation
import Combine
import SnapKit
import UIKit

protocol ChooseLocationOutput {
    var didTouchViewSubject: PassthroughSubject<Void, Never> { get }
}

final class ChooseLocationView: UIView, ChooseLocationOutput {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "위치 선택"
        return label
    }()
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .lightGray
        return label
    }()
    
    private let disclosureIndicator: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.disclosure
        imageView.tintColor = .devFriendsBase
        return imageView
    }()
    
    // MARK: OUTPUT
    var didTouchViewSubject = PassthroughSubject<Void, Never>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        self.backgroundColor = .devFriendsReverseBase
        self.layout()
        self.setupTapGesture()
    }
    
    private func layout() {
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.bottom.equalTo(self.snp.centerY)
        }
        
        self.addSubview(locationLabel)
        locationLabel.snp.makeConstraints { make in
            make.left.equalTo(titleLabel)
            make.top.equalTo(self.snp.centerY).offset(5)
        }
        
        self.addSubview(disclosureIndicator)
        disclosureIndicator.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        self.snp.makeConstraints { make in
            make.height.equalTo(70)
        }
    }
    
    private func setupTapGesture() {
        let tapGestureRecognizer = UITapGestureRecognizer()
        tapGestureRecognizer.delegate = self
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func set(location: Location) {
        Task { [weak self] in
            let placemark = try await CLLocation(latitude: location.latitude, longitude: location.longitude)
                .placemark()
            self?.locationLabel.text = placemark
        }
    }
}

extension ChooseLocationView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        didTouchViewSubject.send()
        return true
    }
}
