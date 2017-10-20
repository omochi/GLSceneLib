#if os(iOS)
    import OpenGLES
#else
    import OpenGL.GL3
#endif

public struct VertexAttributeDefinition {
    public struct Entry {
        public var name: String
        public var type: GLDataType.Type
        public var dimension: Int
        
        public var offset: Int
        public var size: Int
    }
    
    public var entries: [Entry] = []
    
    public var stride: Int {
        return entries.last.map { $0.offset + $0.size } ?? 0
    }
    
    public mutating func addEntry<T: GLDataType>(name: String, type: T.Type, dimension: Int) {
        entries.append(.init(name: name, type: type, dimension: dimension,
                             offset: stride, size: MemoryLayout<T>.size * dimension))
    }
    
    public mutating func addEntry(name: String, type: Vector2.Type) {
        addEntry(name: name, type: GLfloat.self, dimension: 2)
    }
    
    public mutating func addEntry(name: String, type: Vector3.Type) {
        addEntry(name: name, type: GLfloat.self, dimension: 3)
    }
    
    public mutating func addEntry(name: String, type: Vector4.Type) {
        addEntry(name: name, type: GLfloat.self, dimension: 4)
    }
}
