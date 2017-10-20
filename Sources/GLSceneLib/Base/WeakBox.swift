public protocol WeakBoxProtocol {
    associatedtype Value: AnyObject
    
    init(_ x: Value?)
    
    var value: Value? { get }
}

public class WeakBox<T: AnyObject> : WeakBoxProtocol {
    public required init(_ x: T?) {
        self._value = x
    }
    
    public var value: T? {
        return _value
    }
    
    private weak var _value: T?
}

extension Array where Element : WeakBoxProtocol {
    public var unboxedElements: Array<Element.Value> {
        get {
            return flatMap { $0.value }
        }
        set {
            self = newValue.map { Element($0) }
        }
    }
}
