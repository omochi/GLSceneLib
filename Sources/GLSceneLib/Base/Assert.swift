public func assertNotNone<T>(_ reason: @autoclosure () -> String, _ f: () throws -> T?) rethrows -> T {
    guard let x = try f() else {
        fatalError("unexpected none: (\(reason())")
    }
    return x
}

public func assertNotThrow<T>(_ reason: @autoclosure () -> String, _ f: () throws -> T) -> T {
    do {
        return try f()
    } catch let e {
        fatalError("unexpected error: (\(reason()): \(e)")
    }
}
