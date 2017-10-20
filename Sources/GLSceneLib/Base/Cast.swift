public func cast<T>(_ value: Any, to target: T.Type) throws -> T {
    guard let x = value as? T else {
        throw CastError(value: value, target: target)
    }
    return x
}

public struct CastError<T> : Error, CustomStringConvertible {
    public init(value: Any, target: T.Type) {
        self.value = value
        self.target = target
    }
    
    public let value: Any
    public let target: T.Type
    
    public var description: String {
        return "CastError(\(value), type=\(type(of: value)), target=\(target))"
    }
}

