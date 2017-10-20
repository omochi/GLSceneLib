#if os(iOS)
    import OpenGLES
#else
    import OpenGL.GL3
#endif

public class ShaderPrimitive<Vertex>
{
    public class GLPrimitive {
        fileprivate func setNeedsUpdate() { fatalError("abstract") }
        fileprivate func updateIfNeed() { fatalError("abstract") }
        public func draw() { fatalError("abstract") }
    }
    
    public init() {}
    
    public func update<Shader: ShaderProtocol,
        VertexSerializer: VertexSerializerProtocol>(
        shader: Shader,
        vertexSerializer: VertexSerializer
        ) -> GLPrimitive
        where VertexSerializer.Vertex == Vertex
    {
        let primitive = createPrimitiveIfAbsentFor(shader: shader, vertexSerializer: vertexSerializer)
        primitive.updateIfNeed()
        return primitive
    }
    
    private struct PrimitiveKey : Hashable {
        public init(shader: AnyObject,
                    vertexSerializer: AnyObject)
        {
            self.shaderId = ObjectIdentifier(shader)
            self.vertexSerializerId = ObjectIdentifier(vertexSerializer)
        }
        
        public var hashValue: Int {
            var x = 17
            x = 31 &* x &+ shaderId.hashValue
            x = 31 &* x &+ vertexSerializerId.hashValue
            return x
        }
        
        public var shaderId: ObjectIdentifier
        public var vertexSerializerId: ObjectIdentifier
        
        public static func ==(a: PrimitiveKey, b: PrimitiveKey) -> Bool {
            return a.shaderId == b.shaderId &&
                a.vertexSerializerId == b.vertexSerializerId
        }
    }
    
    private class GLPrimitiveImpl<
        Shader: ShaderProtocol,
        VertexSerializer: VertexSerializerProtocol> : GLPrimitive
        where VertexSerializer.Vertex == Vertex
    {
        public weak var owner: ShaderPrimitive<Vertex>?
        public weak var shader: Shader?
        public let vertexSerializer: VertexSerializer
        
        public let vertexArray: GLVertexArray
        public let vertexBuffer: GLBuffer
        public let indexBuffer: GLBuffer
        public var indexCount: Int
        public init(owner: ShaderPrimitive<Vertex>,
                    shader: Shader,
                    vertexSerializer: VertexSerializer)
        {
            self.owner = owner
            self.shader = shader
            self.vertexSerializer = vertexSerializer
            
            self.vertexArray = GLVertexArray()
            self.vertexBuffer = GLBuffer(target: .vertex)
            self.indexBuffer = GLBuffer(target: .index)
            self.indexCount = 0
        }
        
        public override func setNeedsUpdate() {
            needsUpdate = true
        }
        
        public override func updateIfNeed() {
            guard needsUpdate else {
                return
            }
            needsUpdate = false
            
            guard let owner = owner, let shader = shader else {
                return
            }
            
            let vertices = owner.vertices
            let indices = owner.indices
            let attrDef = shader.attributeDefinition
            
            vertexArray.bind()
            vertexBuffer.bind()
            
            vertexSerializer.serialize(vertices: vertices,
                                       attributeDefinition: attrDef) { (ptr, size) in
                                        vertexBuffer.setData(pointer: ptr, size: size)
            }
            
            let stride = attrDef.stride
            attrDef.entries.forEach { attr in
                if let location = shader.glShader.getAttributeLocationOrNone(name: attr.name) {
                    vertexArray.enableAttribute(location: location)
                    vertexArray.setAttributePointer(location: location,
                                                    size: attr.dimension,
                                                    type: attr.type.toGLenum(),
                                                    normalized: false,
                                                    stride: stride,
                                                    ptr: UnsafeRawPointer(bitPattern: attr.offset))
                }
            }
            
            vertexBuffer.unbind()
            vertexArray.unbind()
            
            indexBuffer.bind()
            apply(indices.map { GLushort($0) }) { xs in
                indexBuffer.setData(pointer: xs, size: MemoryLayout<GLushort>.size * xs.count)
            }
            indexBuffer.unbind()
            
            indexCount = indices.count
        }
        
        public override func draw() {
            updateIfNeed()
            
            vertexArray.bind()
            indexBuffer.bind()
            vertexArray.draw(mode: GLenum(GL_TRIANGLES),
                             count: indexCount,
                             type: GLenum(GL_UNSIGNED_SHORT))
            indexBuffer.unbind()
            vertexArray.unbind()
        }
        
        private var needsUpdate: Bool = true
    }
    
    private func createPrimitiveIfAbsentFor<
        Shader: ShaderProtocol,
        VertexSerializer: VertexSerializerProtocol>(
        shader: Shader,
        vertexSerializer: VertexSerializer) -> GLPrimitive
        where VertexSerializer.Vertex == Vertex
    {
        let key = PrimitiveKey(shader: shader, vertexSerializer: vertexSerializer)
        if let renderer = primitiveMap[key] {
            return renderer
        } else {
            let renderer = GLPrimitiveImpl(owner: self,
                                           shader: shader,
                                           vertexSerializer: vertexSerializer)
            primitiveMap[key] = renderer
            return renderer
        }
    }
    
    private func setNeedsUpdate() {
        primitiveMap.values.forEach { renderer in
            renderer.setNeedsUpdate()
        }
    }
    
    private var _vertices: [Vertex] = []
    private var _indices: [Int] = []
    private var primitiveMap: [PrimitiveKey: GLPrimitive] = [:]
}

public extension ShaderPrimitive {
    public var vertices: [Vertex] {
        get {
            return _vertices
        }
        set {
            _vertices = newValue
            setNeedsUpdate()
        }
    }
    
    public var indices: [Int] {
        get {
            return _indices
        }
        set {
            _indices = newValue
            setNeedsUpdate()
        }
    }
}
