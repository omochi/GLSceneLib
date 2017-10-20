public class ColorLinePrimitive {
    public init() {
        inner = ShaderPrimitive<ColorLineShader.Vertex>()
        
        closed = true
        color = Color(white: 1.0, alpha: 1.0)
        width = 1.0
    }
    
    public var points: [Vector3] {
        get {
            return _points
        }
        set {
            _points = newValue
            needsUpdate = true
        }
    }
    
    public var closed: Bool {
        didSet {
            needsUpdate = true
        }
    }
    
    public var color: Color {
        didSet {
            needsUpdate = true
        }
    }
    
    public var width: Float {
        didSet {
            needsUpdate = true
        }
    }
    
    
    public func update() -> ShaderPrimitive<ColorLineShader.Vertex> {
        guard needsUpdate else {
            return inner
        }
        needsUpdate = false
        
        var vertices = [ColorLineShader.Vertex]()
        var indices = [Int]()
        
        let points = self._points
        
        let n = points.count
        
        if n >= 2 {
            
            for i in 0..<n {
                let i99 = (i - 1 + n) % n
                let i0 = i
                let i1 = (i + 1) % n
                
                var v = ColorLineShader.Vertex()
                v.position = points[i0]
                v.fromPosition = points[i99]
                v.extendOffset = 0
                v.color = color
                vertices.append(v)
                
                v.fromPosition = points[i99]
                v.extendOffset = -width / 2
                vertices.append(v)
                
                v.fromPosition = points[i99]
                v.extendOffset = +width / 2
                vertices.append(v)
                
                v.fromPosition = points[i1]
                v.extendOffset = -width / 2
                vertices.append(v)
                
                v.fromPosition = points[i1]
                v.extendOffset = width / 2
                vertices.append(v)
            }
            
            for i in 0..<n {
                let i0 = i
                let i1 = (i + 1) % n
                
                if !closed {
                    if i1 == 0 {
                        break
                    }
                }
                
                indices.append(i0 * 5 + 4)
                indices.append(i0 * 5 + 3)
                indices.append(i1 * 5 + 2)
                
                indices.append(i1 * 5 + 2)
                indices.append(i1 * 5 + 1)
                indices.append(i0 * 5 + 4)
            }
            
            for i in 0..<n {
                if !closed {
                    if i + 2 == n {
                        break
                    }
                }
                
                indices.append(i * 5 + 0)
                indices.append(i * 5 + 4)
                indices.append(i * 5 + 1)
                
                indices.append(i * 5 + 0)
                indices.append(i * 5 + 2)
                indices.append(i * 5 + 3)
            }
            
        }
        
        inner.vertices = vertices
        inner.indices = indices
        
        return inner
    }
    
    private let inner: ShaderPrimitive<ColorLineShader.Vertex>
    
    private var needsUpdate: Bool = true
    private var _points: [Vector3] = []
}

