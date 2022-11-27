//
//  ChooseCategoryView.swift
//  DevFriends
//
//  Created by 이대현 on 2022/11/27.
//

import Combine
import SnapKit
import UIKit

protocol ChooseCategoryOutput {
    var didTouchViewSubject: PassthroughSubject<Void, Never> { get }
}

final class ChooseCategoryView: UIView, ChooseCategoryOutput {
    private lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.text = "카테고리 선택"
        return label
    }()
    
    private lazy var categoryStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 9
        stackView.addArrangedSubview(createInterestLabel("C언어"))
        stackView.addArrangedSubview(createInterestLabel("Swift"))
        return stackView
    }()
    
    private lazy var disclosureIndicator: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.tintColor = .black
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
        self.backgroundColor = .white
        self.layout()
        self.setupTapGesture()
    }
    
    private func createInterestLabel(_ text: String) -> FilledRoundTextLabel {
        let text = "# " + text
        let defaultColor = UIColor(red: 0.907, green: 0.947, blue: 0.876, alpha: 1)
        let interestLabel = FilledRoundTextLabel(text: text, backgroundColor: defaultColor, textColor: .black)
        
        return interestLabel
    }
    
    private func layout() {
        self.addSubview(categoryLabel)
        categoryLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.bottom.equalTo(self.snp.centerY)
        }
        
        self.addSubview(categoryStack)
        categoryStack.snp.makeConstraints { make in
            make.left.equalTo(categoryLabel)
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
}

extension ChooseCategoryView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        print("gestureRecognizer")
        didTouchViewSubject.send()
        return true
    }
}
