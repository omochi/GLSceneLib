import CoreGraphics
import DebugReflect

public struct Size: CustomStringConvertible, DebugReflectable {
    public init() {}
    
    public init(width: Float, height: Float) {
        self.width = width
        self.height = height
    }
    
    public init(_ size: CGSize) {
        self.init(width: Float(size.width), height: Float(size.height))
    }
    
    public init(_ vector: Vector2) {
        self.init(width: vector.x, height: vector.y)
    }
    
    public var width: Float = 0
    public var height: Float = 0
    
    public var description: String {
        return debugDescription
    }
    
    public func debugReflect() -> DebugReflectValue {
        return .string("\(width), \(height)")
    }
    
    public func toVector() -> Vector2 {
        return Vector2(width, height)
    }
}

