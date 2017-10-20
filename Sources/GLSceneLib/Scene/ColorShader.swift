public class ColorShader : BasicTransformShaderProtocol {
    public struct Vertex {
        public init() {}
        public init(position: Vector3, color: Color) {
            self.position = position
            self.color = color
        }
        public var position: Vector3 = .init()
        public var color: Color = .init()
    }
    
    public class VertexSerializer : VertexSerializerProtocol {
        public func attributeValueOf(vertex v: Vertex, name: String) -> VertexAttribute {
            switch name {
            case "position":
                return .init(v.position)
            case "color":
                return .init(v.color.toVector())
            default:
                fatalError("invalid name: \(name)")
            }
        }
        
        public static let shared = VertexSerializer()
    }
    
    public init() {
        attributeDefinition = run {
            var def = VertexAttributeDefinition()
            def.addEntry(name: "position", type: Vector3.self)
            def.addEntry(name: "color", type: Vector4.self)
            return def
        }
        glShader = ColorShader.createShader()
    }
    
    public let attributeDefinition: VertexAttributeDefinition
    public let glShader: GLShader
    
    public var modeling: Matrix4x4 = .identity
    public var viewing: Matrix4x4 = .identity {
        didSet {
            needsTransferViewing = true
        }
    }
    
    public var projection: Matrix4x4 = .identity {
        didSet {
            needsTransferProjection = true
        }
    }
    
    public func draw<V, VS>(primitive: ShaderPrimitive<V>,
                            vertexSerializer: VS)
        where VS: VertexSerializerProtocol, VS.Vertex == V
    {
        let glPrimitive = primitive.update(shader: self, vertexSerializer: vertexSerializer)
        glShader.use()
        glShader.setUniform(name: "modeling", value: modeling)
        
        if needsTransferViewing {
            glShader.setUniform(name: "viewing", value: viewing)
            needsTransferViewing = false
        }
        
        if needsTransferProjection {
            glShader.setUniform(name: "projection", value: projection)
            needsTransferProjection = false
        }
        
        glPrimitive.draw()
        glShader.unuse()
    }
    
    private var needsTransferViewing: Bool = true
    private var needsTransferProjection: Bool = true
    
    private static func createShader() -> GLShader {
        let vsh = """
#version 300 es
uniform highp mat4 modeling;
uniform highp mat4 viewing;
uniform highp mat4 projection;
in highp vec3 position;
in lowp vec4 color;
out lowp vec4 v_color;
void main() {
    highp vec4 pos = projection * viewing * modeling * vec4(position, 1);
    gl_Position = pos;
    v_color = color;
}
"""
        
        let fsh = """
#version 300 es
in lowp vec4 v_color;
out lowp vec4 o_color;
void main() {
    o_color = v_color;
}
"""
        
        return assertNotThrow("color shader source") {
            return try GLShader(vertexShaderSource: vsh, fragmentShaderSource: fsh)
        }
    }
}
