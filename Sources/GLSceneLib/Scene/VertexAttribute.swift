public struct VertexAttribute {
    public init<T: GLDataType>(_ array: [T]) {
        self.box = _ArrayVertexAttributeBox(array)
    }
    
    public init<T: GLDataType>(_ value: T) {
        self.init([value])
    }
    
    public init(_ value: Vector2) {
        self.init(value.toGL())
    }
    
    public init(_ value: Vector3) {
        self.init(value.toGL())
    }
    
    public init(_ value: Vector4) {
        self.init(value.toGL())
    }
    
    public func write(to: UnsafeMutableRawPointer) {
        box.write(to: to)
    }
    
    private let box: _VertexAttributeBox
}

public class _VertexAttributeBox {
    public func write(to: UnsafeMutableRawPointer) { fatalError("abstract") }
}

public class _ArrayVertexAttributeBox<T: GLDataType> : _VertexAttributeBox {
    public init(_ value: [T]) {
        self.value = value
    }
    
    public let value: [T]
    
    public override func write(to: UnsafeMutableRawPointer) {
        var p = to
        let size = MemoryLayout<T>.size
        value.forEach { v in
            v.write(to: p)
            p += size
        }
    }
}

