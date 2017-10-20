public func optionalEquals<T>(_ a: T?, _ b: T?, _ f: (T, T) throws -> Bool) rethrows -> Bool {
    switch (a, b) {
    case let (.some(aw), .some(bw)):
        return try f(aw, bw)
    case (.none, .none):
        return true
    default:
        return false
    }
}

