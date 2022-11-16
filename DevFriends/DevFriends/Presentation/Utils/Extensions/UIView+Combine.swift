//
//  UIView+Combine.swift
//  DevFriends
//
//  Created by 심주미 on 2022/11/16.
//

import Combine
import UIKit

extension UIView {
    enum GestureType {
        case tap(UITapGestureRecognizer = .init())
        
        func get() -> UITapGestureRecognizer {
            switch self {
            case let .tap(tapGesture):
                return tapGesture
            }
        }
    }

    struct GesturePublisher: Publisher {
        typealias Output = GestureType
        typealias Failure = Never
        
        private let view: UIView
        private let gestureType: GestureType
        
        init(view: UIView, gestureType: GestureType) {
            self.view = view
            self.gestureType = gestureType
        }
        
        func receive<S>(subscriber: S) where S: Subscriber, Never == S.Failure, GestureType == S.Input {
            let subscription = GestureSubscription(subscriber: subscriber,
                                                   view: view,
                                                   gestureType: gestureType)
            subscriber.receive(subscription: subscription)
        }
    }

    final class GestureSubscription<S: Subscriber>: Subscription where S.Input == GestureType, S.Failure == Never {
        
        private var subscriber: S?
        private var gestureType: GestureType
        private var view: UIView
        
        init(subscriber: S, view: UIView, gestureType: GestureType) {
            self.subscriber = subscriber
            self.view = view
            self.gestureType = gestureType
            configureGesture(gestureType)
        }
        
        private func configureGesture(_ gestureType: GestureType) {
            let gesture = gestureType.get()
            gesture.addTarget(self, action: #selector(handler))
            view.addGestureRecognizer(gesture)
        }
        
        func request(_ demand: Subscribers.Demand) { }
        
        func cancel() {
            subscriber = nil
        }
        
        @objc private func handler() {
            _ = subscriber?.receive(gestureType)
        }
    }
    
    func gesturePublisher(_ gestureType: GestureType = .tap()) -> GesturePublisher {
        .init(view: self, gestureType: gestureType)
    }
}
