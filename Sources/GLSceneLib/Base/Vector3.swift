import Foundation
import DebugReflect

public struct Vector3 : CustomStringConvertible, Equatable, DebugReflectable {
    public init() {}
    
    public init(_ x: Float, _ y: Float, _ z: Float) {
        self.x = x
        self.y = y
        self.z = z
    }
    
    public var x: Float = 0
    public var y: Float = 0
    public var z: Float = 0
    
    public var description: String {
        return debugDescription
    }
    
    public func debugReflect() -> DebugReflectValue {
        return .string("\(x), \(y), \(z)")
    }
    
    public var elements: [Float] {
        return [x, y, z]
    }
    
    public var length: Float {
        return sqrt(x * x + y * y + z * z)
    }
    
    public mutating func normalize() {
        let len = length
        x /= len
        y /= len
        z /= len
    }
    
    public func normalized() -> Vector3 {
        var ret = self
        ret.normalize()
        return ret
    }
    
    public func dot(_ o: Vector3) -> Float {
        return x * o.x + y * o.y + z * o.z
    }
    
    public func cross(_ o: Vector3) -> Vector3 {
        return Vector3(
            y * o.z - z * o.y,
            z * o.x - x * o.z,
            x * o.y - y * o.x)
    }
    
    public mutating func project(_ o: Vector3) {
        self = projected(o)
    }
    
    public func projected(_ o: Vector3) -> Vector3 {
        let d = dot(o)
        return d * o.normalized()
    }
    
    public mutating func transformIn3D(_ m: Matrix4x4) {
        self = transformedIn3D(m)
    }
    
    public func transformedIn3D(_ m: Matrix4x4) -> Vector3 {
        let v = to4(w: 1) * m
        return v.to3() / v.w
    }
    
    public func blended(_ o: Vector3, rate: Float) -> Vector3 {
        return self * (1.0 - rate) + o * rate
    }
    
    public func to2() -> Vector2 {
        return Vector2(x, y)
    }
    
    public func to4(w: Float) -> Vector4 {
        return Vector4(x, y, z, w)
    }
}


public func ==(a: Vector3, b: Vector3) -> Bool {
    return a.x == b.x && a.y == b.y && a.z == b.z
}

public func + (a: Vector3, b: Vector3) -> Vector3 {
    return Vector3(a.x + b.x, a.y + b.y, a.z + b.z)
}

public func += (a: inout Vector3, b: Vector3) {
    a = a + b
}

public prefix func - (a: Vector3) -> Vector3 {
    return Vector3(-a.x, -a.y, -a.z)
}

public func - (a: Vector3, b: Vector3) -> Vector3 {
    return Vector3(a.x - b.x, a.y - b.y, a.z - b.z)
}

public func -= (a: inout Vector3, b: Vector3) {
    a = a - b
}

public func * (a: Float, b: Vector3) -> Vector3 {
    return Vector3(a * b.x, a * b.y, a * b.z)
}

public func * (a: Vector3, b: Float) -> Vector3 {
    return b * a
}

public func *= (a: inout Vector3, b: Float) {
    a = a * b
}

public func / (a: Vector3, b: Float) -> Vector3 {
    return (1.0 / b) * a
}

public func /= (a: inout Vector3, b: Float) {
    a = a / b
}


