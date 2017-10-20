import DebugReflect

public struct OpaqueColor : CustomStringConvertible, DebugReflectable {
    public init() {}
    
    public init(red: Float, green: Float, blue: Float) {
        self.red = red
        self.green = green
        self.blue = blue
    }
    
    public init(_ vector: Vector3) {
        self.init(red: vector.x, green: vector.y, blue: vector.z)
    }
    
    public init(white: Float) {
        self.init(red: white, green: white, blue: white)
    }
    
    public var red: Float = 1
    public var green: Float = 1
    public var blue: Float = 1
    
    public var description: String {
        return debugDescription
    }
    
    public func debugReflect() -> DebugReflectValue {
        return .string("\(red), \(green), \(blue)")
    }
    
    public func toVector() -> Vector3 {
        return Vector3(red, green, blue)
    }
    
    public func toColor(alpha: Float) -> Color {
        return Color(red: red, green: green, blue: blue, alpha: alpha)
    }
}

