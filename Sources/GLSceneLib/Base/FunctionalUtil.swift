public func run<R>(_ f: () throws -> R) rethrows -> R {
    return try f()
}

public func apply<T, R>(_ x: T, _ f: (T) throws -> R) rethrows -> R {
    return try f(x)
}

public func map<T, R>(_ x: T?, _ f: (T) throws -> R) rethrows -> R? {
    return try x.map(f)
}
