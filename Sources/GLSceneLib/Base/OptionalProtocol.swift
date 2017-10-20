public protocol OptionalProtocol {
    associatedtype WrappedType
    func asOptional() -> WrappedType?
}

extension Optional : OptionalProtocol {
    public func asOptional() -> Wrapped? {
        return self
    }
}
