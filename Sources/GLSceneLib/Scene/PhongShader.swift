public class PhongShader : BasicTransformShaderProtocol {
    public struct Vertex {
        public init() {}
        public init(position: Vector3,
                    normal: Vector3,
                    color: Color)
        {
            self.position = position
            self.normal = normal
            self.color = color
        }
        
        public var position: Vector3 = .init()
        public var normal: Vector3 = .init()
        public var color: Color = .init()
    }
    
    public class VertexSerializer : VertexSerializerProtocol {
        public func attributeValueOf(vertex v: Vertex, name: String) -> VertexAttribute {
            switch name {
            case "position":
                return .init(v.position)
            case "normal":
                return .init(v.normal.normalized())
            case "color":
                return .init(v.color.toVector())
            default:
                fatalError("invalid name: \(name)")
            }
        }
        
        public static let shared = VertexSerializer()
    }
    
    public typealias Primitive = ShaderPrimitive<Vertex>
    
    public struct ShaderLight {
        public var position: Vector4 = .init(0, 0, 0, 1)
        public var color: OpaqueColor = .init(white: 0)
        public var ambientFactor: Float = 0
        
        public init() {}
        
        public init(position: Vector4,
                    color: OpaqueColor,
                    ambientFactor: Float)
        {
            self.position = position
            self.color = color
            self.ambientFactor = ambientFactor
        }
    }
    
    public static let shaderLightNum: Int = 4
    
    public init() {
        attributeDefinition = run {
            var def = VertexAttributeDefinition()
            def.addEntry(name: "position", type: Vector3.self)
            def.addEntry(name: "normal", type: Vector3.self)
            def.addEntry(name: "color", type: Vector4.self)
            return def
        }
        glShader = PhongShader.createShader()
        
        let defaultLight = DirectionalLight(direction: .init(0, 0, -1),
                                            color: .init(white: 1),
                                            ambientFactor: 0.2)
        lights.append(defaultLight)
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
    
    public var lights: [Light] = [] {
        didSet {
            needsTransferLights = true
        }
    }
    
    public func draw<V, VS>(primitive: ShaderPrimitive<V>,
                            vertexSerializer: VS)
        where VS: VertexSerializerProtocol, VS.Vertex == V
    {
        let normalTransform = (modeling * viewing).inverted().transposed()
        
        let glPrimitive = primitive.update(shader: self, vertexSerializer: vertexSerializer)
        glShader.use()
        glShader.setUniform(name: "modeling", value: modeling)
        glShader.setUniform(name: "normalTransform", value: normalTransform)
        
        if needsTransferViewing {
            glShader.setUniform(name: "viewing", value: viewing)
            needsTransferViewing = false
        }
        
        if needsTransferProjection {
            glShader.setUniform(name: "projection", value: projection)
            needsTransferProjection = false
        }
        
        if needsTransferLights {
            transferLights()
            needsTransferLights = false
        }
        
        glPrimitive.draw()
        glShader.unuse()
    }
    
    private func transferLights() {
        for i in 0..<PhongShader.shaderLightNum {
            let shaderLight: ShaderLight = run {
                if let light = lights.getOrNone(at: i) {
                    switch light {
                    case let light as DirectionalLight:
                        let node = assertNotNone("light node") { light.nodes.first }
                        let directionInCamera = (light.direction.to4(w: 0) * node.worldTransform * viewing).to3().normalized()
                        return .init(position: (-1.0 * directionInCamera).to4(w: 0.0),
                                     color: light.color,
                                     ambientFactor: light.ambientFactor)
                    default:
                        return ShaderLight()
                    }
                } else {
                    return ShaderLight()
                }
            }
            
            glShader.setUniform(name: "lights[\(i)].position", value: shaderLight.position)
            glShader.setUniform(name: "lights[\(i)].color", value: shaderLight.color.toVector())
            glShader.setUniform(name: "lights[\(i)].ambientFactor", value: shaderLight.ambientFactor)
        }
    }
    
    private var needsTransferViewing: Bool = true
    private var needsTransferProjection: Bool = true
    private var needsTransferLights: Bool = true
    
    public static func createShader() -> GLShader {
        let lightDef = """
struct Light {
    highp vec4 position;
    lowp vec3 color;
    highp float ambientFactor;
};
const int lightNum = 4;
uniform Light lights[lightNum];
"""
        
        let vsh = """
#version 300 es

\(lightDef)

uniform highp mat4 modeling;
uniform highp mat4 viewing;
uniform highp mat4 projection;
uniform highp mat4 normalTransform;

in highp vec3 position;
in highp vec3 normal;
in lowp vec4 color;

out highp vec3 v_position;
out highp vec3 v_normal;
out lowp vec4 v_color;
void main() {
    v_position = (viewing * modeling * vec4(position, 1)).xyz;
    gl_Position = projection * vec4(v_position, 1);
    v_normal = normalize(mat3(normalTransform) * normal);
    v_color = color;
}
"""
        
        let fsh = """
#version 300 es

\(lightDef)
        
in highp vec3 v_position;
in highp vec3 v_normal;
in lowp vec4 v_color;
out lowp vec4 o_color;

highp float calcLightFactor(int lightIndex) {
    Light light = lights[lightIndex];
    highp vec3 wLightDirection = light.position.xyz - light.position.w * v_position;
    highp vec3 lightDirection = normalize(wLightDirection);
    highp float lightDistance = length(wLightDirection) / light.position.w;
    highp float diffuseFactor = max(0.0, dot(v_normal, lightDirection));
    return light.ambientFactor + diffuseFactor;
}

void main() {
    o_color = v_color;

    highp vec3 surfaceColor = vec3(0, 0, 0);
    for (int i = 0; i < lightNum; i++) {
        surfaceColor += calcLightFactor(i) * lights[i].color;
    }

    highp float surfaceAlpha = v_color.a;

    highp vec3 normalColor = v_normal * 0.5 + vec3(0.5, 0.5, 0.5);
    o_color = vec4(surfaceColor, surfaceAlpha);
}
"""
        
        return assertNotThrow("phong shader") {
            return try GLShader(vertexShaderSource: vsh, fragmentShaderSource: fsh)
        }
    }
    
}
