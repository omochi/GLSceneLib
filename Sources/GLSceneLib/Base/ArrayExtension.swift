extension Array {
    public mutating func remove(_ pred: (Element) throws -> Bool) rethrows {
        self = try self.filter { try !pred($0) }
    }
    
    public func getOrNone(at index: Int) -> Element? {
        guard 0 <= index && index < count else {
            return nil
        }
        return self[index]
    }
    
    public func testAll(_ pred: (Element) throws -> Bool) rethrows -> Bool {
        for x in self {
            if try !pred(x) {
                return false
            }
        }
        return true
    }
    
    public func testAny(_ pred: (Element) throws -> Bool) rethrows -> Bool {
        for x in self {
            if try pred(x) {
                return true
            }
        }
        return false
    }

    public func withUnsafeBufferPointerArray<T, R>(_ body: (Array<UnsafeBufferPointer<T>>) throws -> R) rethrows -> R
        where Element == Array<T>
    {
        var buffers = Array<UnsafeBufferPointer<T>>()
        var result: R?
        
        func recurse(body: (Array<UnsafeBufferPointer<T>>) throws -> R) rethrows {
            let i = buffers.count
            guard i < self.count else {
                result = try body(buffers)
                return
            }
            try self[i].withUnsafeBufferPointer { (buf: UnsafeBufferPointer<T>) in
                buffers.append(buf)
                try recurse(body: body)
            }
        }
        
        try recurse(body: body)
        
        return result!
    }
}

extension Array where Element: OptionalProtocol {
    public func filterNone() -> Array<Element.WrappedType> {
        return flatMap { $0.asOptional() }
    }
}


