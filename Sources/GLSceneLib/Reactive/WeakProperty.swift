import Foundation

public class WeakProperty<T: AnyObject> : EventSourceProtocol {
    public init(_ value: T?) {
        self._value = value
    }
    
    public var value: T? {
        get {
            return _value
        }
        set {
            _value = newValue
            event.emit(_value)
        }
    }
    
    public func addHandler(_ handler: @escaping (T?) -> ()) -> Disposer {
        let disposer = event.addHandler(handler)
        handler(_value)
        return disposer
    }
    
    private weak var _value: T?
    private let event = EventEmitter<T?>()
}
