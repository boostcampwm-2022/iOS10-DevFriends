//
//  UIBarButtonItem+Combine.swift
//  DevFriends
//
//  Created by 유승원 on 2022/12/03.
//

import Combine
import UIKit

public extension UIBarButtonItem {
    final class Subscription<SubscriberType: Subscriber, Input: UIBarButtonItem>: Combine.Subscription
    where SubscriberType.Input == Input {
        private var subscriber: SubscriberType?
        private let input: Input

        public init(subscriber: SubscriberType, input: Input) {
            self.subscriber = subscriber
            self.input = input
            input.target = self
            input.action = #selector(eventHandler)
        }
        
        public func request(_ demand: Subscribers.Demand) {}
        
        public func cancel() {
            subscriber = nil
        }
        
        @objc private func eventHandler() {
            _ = subscriber?.receive(input)
        }
    }
    
    struct Publisher<Output: UIBarButtonItem>: Combine.Publisher {
        public typealias Output = Output
        public typealias Failure = Never
        
        let output: Output
        
        public init(output: Output) {
            self.output = output
        }
        
        public func receive<S>(subscriber: S) where S: Subscriber, Self.Failure == S.Failure, Self.Output == S.Input {
            let subscription = Subscription(subscriber: subscriber, input: output)
            subscriber.receive(subscription: subscription)
        }
    }
}

public protocol CombineCompatible {}

public extension CombineCompatible where Self: UIBarButtonItem {
    var publisher: UIBarButtonItem.Publisher<UIBarButtonItem> {
        .init(output: self)
    }
}

extension UIBarButtonItem: CombineCompatible {}
