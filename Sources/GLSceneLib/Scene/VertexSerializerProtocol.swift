public protocol VertexSerializerProtocol : class {
    associatedtype Vertex
    
    func attributeValueOf(vertex: Vertex, name: String) -> VertexAttribute
}

public extension VertexSerializerProtocol {
    func serialize(vertices: [Vertex],
                   attributeDefinition: VertexAttributeDefinition,
                   _ f: (_ memory: UnsafeRawPointer?, _ size: Int) -> Void) {
        let stride = attributeDefinition.stride
        let size = stride * vertices.count
        if size == 0 {
            f(nil, 0)
            return
        }
        
        let alignment = 8
        let buf = UnsafeMutableRawPointer.allocate(bytes: size, alignedTo: alignment)
        defer {
            buf.deallocate(bytes: size, alignedTo: alignment)
        }
        var p = buf
        vertices.forEach { vertex in
            attributeDefinition.entries.forEach { attr in
                let v = attributeValueOf(vertex: vertex, name: attr.name)
                v.write(to: p + attr.offset)
            }
            p += stride
        }
        f(buf, size)
    }
}
