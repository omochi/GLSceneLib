#if os(iOS)
    import OpenGLES
#else
    import OpenGL.GL3
#endif

public class ColorLineShader : BasicTransformShaderProtocol {
    public struct Vertex {
        public init() {}
        
        public var position: Vector3 = .init()
        public var fromPosition: Vector3 = .init()
        public var extendOffset: Float = .init()
        public var color: Color = .init()
    }
    
    public class VertexSerializer : VertexSerializerProtocol {
        public func attributeValueOf(vertex v: Vertex, name: String) -> VertexAttribute {
            switch name {
            case "position":
                return .init(v.position)
            case "fromPosition":
                return .init(v.fromPosition)
            case "extendOffset":
                return .init(v.extendOffset)
            case "color":
                return .init(v.color.toVector())
            default:
                fatalError("invalid name: \(name)")
            }
        }
        
        public static let shared = VertexSerializer()
    }
    
    public init() {
        glShader = ColorLineShader.createShader()
        
        attributeDefinition = run {
            var def = VertexAttributeDefinition()
            def.addEntry(name: "position", type: Vector3.self)
            def.addEntry(name: "fromPosition", type: Vector3.self)
            def.addEntry(name: "extendOffset", type: GLfloat.self, dimension: 1)
            def.addEntry(name: "color", type: Vector4.self)
            return def
        }
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
    
    public var viewportSize: Size = Size() {
        didSet {
            needsTransferViewportSize = true
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
        
        if needsTransferViewportSize {
            glShader.setUniform(name: "viewportSize", value: viewportSize.toVector())
            needsTransferViewportSize = false
        }
        
        glPrimitive.draw()
        glShader.unuse()
    }
    
    public func draw(primitive: ColorLinePrimitive) {
        let inner = primitive.update()
        draw(primitive: inner,
             vertexSerializer: ColorLineShader.VertexSerializer.shared)
    }
    
    public func draw(primitive: ColorLineCirclePrimitive) {
        let inner = primitive.update()
        draw(primitive: inner)
    }
    
    private var needsTransferViewing: Bool = true
    private var needsTransferProjection: Bool = true
    private var needsTransferViewportSize: Bool = true
    
    private static func createShader() -> GLShader {
        let vsh = """
#version 300 es

uniform highp mat4 modeling;
uniform highp mat4 viewing;
uniform highp mat4 projection;
uniform highp vec2 viewportSize;
in highp vec3 position;
in highp vec3 fromPosition;
in mediump float extendOffset;
in lowp vec4 color;
out lowp vec4 v_color;

mat3 makeRotationIn2D(float angle) {
    float c = cos(angle);
    float s = sin(angle);
    return mat3( c,  s, 0,
                -s,  c, 0,
                 0,  0, 1);
}

vec3 transformIn3D(mat4 m, vec3 v) {
    vec4 r = m * vec4(v, 1.0);
    return r.xyz / r.w;
}

vec2 transformIn2D(mat3 m, vec2 v) {
    vec3 r = m * vec3(v, 1.0);
    return r.xy / r.z;
}

vec3 cameraToScreen(mat4 proj, vec2 viewportSize, vec3 pos) {
    pos = transformIn3D(projection, pos);
    pos.x *= viewportSize.x / 2.0;
    pos.y *= viewportSize.y / 2.0;
    return pos;
}

vec3 screenToCamera(mat4 invProj, vec2 viewportSize, vec3 pos) {
    pos.x *= 2.0 / viewportSize.x;
    pos.y *= 2.0 / viewportSize.y;
    return transformIn3D(invProj, pos);
}

vec2 screenDeltaToCamera(mat4 invProj, vec2 viewportSize, float z, vec2 delta) {
    vec3 p0InScreen = vec3(0.0, 0.0, z);
    vec3 p1InScreen = vec3(delta, z);
    vec3 p0InCamera = screenToCamera(invProj, viewportSize, p0InScreen);
    vec3 p1InCamera = screenToCamera(invProj, viewportSize, p1InScreen);
    return p1InCamera.xy - p0InCamera.xy;
}

void main() {
    mat4 invProjection = inverse(projection);

    mat4 localToCamera = viewing * modeling;
    vec3 posInCamera = transformIn3D(localToCamera, position);
    vec3 fromPosInCamera = transformIn3D(localToCamera, fromPosition);
    vec3 fromPosInCamera2 = normalize(fromPosInCamera - posInCamera) * 0.01 + posInCamera;

    vec3 posInScreen = cameraToScreen(projection, viewportSize, posInCamera);
    vec3 fromPosInScreen = cameraToScreen(projection, viewportSize, fromPosInCamera2);

    mat3 rot = makeRotationIn2D(radians(-90.0)); // clip space is left-handed
    vec2 extendDirectionInScreen = normalize(transformIn2D(rot, posInScreen.xy - fromPosInScreen.xy));
    vec2 extendInScreen = extendOffset * extendDirectionInScreen;

    vec2 extendInCamera = screenDeltaToCamera(invProjection, viewportSize, posInScreen.z,
                                              extendInScreen);

    vec3 extendPosInCamera = posInCamera + vec3(extendInCamera, 0.0);

    gl_Position = projection * vec4(extendPosInCamera, 1);

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
        
        return assertNotThrow("color line shader source") {
            return try GLShader(vertexShaderSource: vsh, fragmentShaderSource: fsh)
        }
    }
}
