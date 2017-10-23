//
//  Property.swift
//  GLSceneLib
//
//  Created by omochimetaru on 2017/10/23.
//  Copyright © 2017年 omochimetaru. All rights reserved.
//

import Foundation

public class Property<T> : EventSourceProtocol {    
    public init(_ value: T) {
        self._value = value
    }
    
    public var value: T {
        get {
            return _value
        }
        set {
            _value = newValue
            event.emit(_value)
        }
    }
    
    public func addHandler(_ handler: @escaping (T) -> ()) -> Disposer {
        let disposer = event.addHandler(handler)
        handler(_value)
        return disposer
    }
    
    private var _value: T
    private let event = EventEmitter<T>()
}
