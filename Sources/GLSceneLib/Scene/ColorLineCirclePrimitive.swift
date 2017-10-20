import Foundation

public class ColorLineCirclePrimitive {
    public init() {
        inner = ColorLinePrimitive()
        inner.closed = true
    }
    
    public var center: Vector3 = Vector3() {
        didSet {
            needsUpdate = true
        }
    }
    public var radius: Float = 0.5 {
        didSet {
            needsUpdate = true
        }
    }
    
    public var splitNum: Int = 24 {
        didSet {
            needsUpdate = true
        }
    }
    
    public var lineWidth: Float {
        get {
            return inner.width
        }
        set {
            inner.width = newValue
        }
    }
    public var color: Color {
        get {
            return inner.color
        }
        set {
            inner.color = newValue
        }
    }
    
    public func update() -> ColorLinePrimitive
    {
        guard needsUpdate else {
            return inner
        }
        needsUpdate = false
        
        var points = [Vector3]()
        
        points.removeAll()
        for i in 0..<splitNum {
            let angle = toRadian(360.0 * Float(i) / Float(splitNum))
            let x = radius * cos(angle)
            let y = radius * sin(angle)
            points.append(center + Vector3(x, y, 0))
        }
        
        inner.points = points
        return inner
    }
    
    private var needsUpdate: Bool = true
    private let inner: ColorLinePrimitive
}

