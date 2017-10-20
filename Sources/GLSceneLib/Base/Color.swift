#if os(iOS)
import UIKit
#endif
import DebugReflect

public struct Color : CustomStringConvertible, DebugReflectable {
    public init() {}
    
    public init(red: Float, green: Float, blue: Float, alpha: Float) {
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }
    
    public init(_ vector: Vector4) {
        self.init(red: vector.x, green: vector.y, blue: vector.z, alpha: vector.w)
    }
    
    public init(white: Float, alpha: Float) {
        self.init(red: white, green: white, blue: white, alpha: alpha)
    }
    
    public var red: Float = 1
    public var green: Float = 1
    public var blue: Float = 1
    public var alpha: Float = 1
    
    public var description: String {
        return debugDescription
    }
    
    public func debugReflect() -> DebugReflectValue {
        return .string("\(red), \(green), \(blue), \(alpha)")
    }
    
    public func toVector() -> Vector4 {
        return Vector4(red, green, blue, alpha)
    }
    
    public func toOpaque() -> OpaqueColor {
        return OpaqueColor(red: red, green: green, blue: blue)
    }
    
    #if os(iOS)
    public func toUIColor() -> UIColor {
        return UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: CGFloat(alpha))
    }
    #endif
}


