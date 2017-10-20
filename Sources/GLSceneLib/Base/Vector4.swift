import Foundation
import DebugReflect

public struct Vector4 : CustomStringConvertible, DebugReflectable {
    
    public init() {}
    
    public init(_ x: Float, _ y: Float, _ z: Float, _ w: Float) {
        self.x = x
        self.y = y
        self.z = z
        self.w = w
    }
    
    public var x: Float = 0
    public var y: Float = 0
    public var z: Float = 0
    public var w: Float = 0
    
    public var description: String {
        return debugDescription
    }
    
    public func debugReflect() -> DebugReflectValue {
        return .string("\(x), \(y), \(z), \(w)")
    }
    
    public var elements: [Float] {
        return [x, y, z, w]
    }
    
    public func to3() -> Vector3 {
        return Vector3(x, y, z)
    }
}

public func + (a: Vector4, b: Vector4) -> Vector4 {
    return Vector4(a.x + b.x, a.y + b.y, a.z + b.z, a.w + b.w)
}

public func += (a: inout Vector4, b: Vector4) {
    a = a + b
}

public prefix func - (a: Vector4) -> Vector4 {
    return Vector4(-a.x, -a.y, -a.z, -a.w)
}

public func - (a: Vector4, b: Vector4) -> Vector4 {
    return Vector4(a.x - b.x, a.y - b.y, a.z - b.z, a.w - b.w)
}

public func -= (a: inout Vector4, b: Vector4) {
    a = a - b
}


