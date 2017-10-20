import Foundation
import DebugReflect

public struct Vector2 : CustomStringConvertible, DebugReflectable {
    public init() {}
    
    public init(_ x: Float, _ y: Float) {
        self.x = x
        self.y = y
    }
    
    public var x: Float = 0
    public var y: Float = 0
    
    public var elements: [Float] {
        return [x, y]
    }
    
    public var description: String {
        return debugDescription
    }
    
    public func debugReflect() -> DebugReflectValue {
        return .string("\(x), \(y)")
    }
    
    public func to3(z: Float) -> Vector3 {
        return Vector3(x, y, z)
    }
}

public func ==(a: Vector2, b: Vector2) -> Bool {
    return a.x == b.x && a.y == b.y
}

public func + (a: Vector2, b: Vector2) -> Vector2 {
    return Vector2(a.x + b.x, a.y + b.y)
}

public func += (a: inout Vector2, b: Vector2) {
    a = a + b
}

public prefix func - (a: Vector2) -> Vector2 {
    return Vector2(-a.x, -a.y)
}

public func - (a: Vector2, b: Vector2) -> Vector2 {
    return Vector2(a.x - b.x, a.y - b.y)
}

public func -= (a: inout Vector2, b: Vector2) {
    a = a - b
}

public func * (a: Float, b: Vector2) -> Vector2 {
    return Vector2(a * b.x, a * b.y)
}

public func * (a: Vector2, b: Float) -> Vector2 {
    return b * a
}

public func *= (a: inout Vector2, b: Float) {
    a = a * b
}

public func / (a: Vector2, b: Float) -> Vector2 {
    return (1.0 / b) * a
}

public func /= (a: inout Vector2, b: Float) {
    a = a / b
}

