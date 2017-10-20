public class MeshElement : SceneElement, BasicSceneElementProtocol {
    public typealias Vertex = PhongShader.Vertex
    
    public override required init() {
        primitive = ShaderPrimitive<Vertex>()
        super.init()
    }
    
    public var vertices: [Vertex] {
        get {
            return primitive.vertices
        }
        set {
            primitive.vertices = newValue
        }
    }
    
    public var indices: [Int] {
        get {
            return primitive.indices
        }
        set {
            primitive.indices = newValue
        }
    }
    
    public var setting: RenderSetting = RenderSetting()
    public var visible: Bool = true
    public var lighting: Bool = true
    
    public func clear() {
        primitive.vertices.removeAll()
        primitive.indices.removeAll()
    }
    
    public func addVertex(_ v: Vertex) {
        primitive.vertices.append(v)
    }
    
    public func addIndex(_ i: Int) {
        primitive.indices.append(i)
    }
    
    public override func render(with renderer: SceneRenderer,
                                node: SceneNode)
    {
        guard visible else {
            return
        }
        
        setting.apply()
        
        if lighting {
            let shader = renderer.phongShader
            shader.modeling = node.worldTransform
            shader.draw(primitive: primitive, vertexSerializer: PhongShader.VertexSerializer.shared)
        } else {
            let shader = renderer.colorShader
            shader.modeling = node.worldTransform
            shader.draw(primitive: primitive, vertexSerializer: PhongShader.VertexSerializer.shared)
        }
        
        setting.clear()
    }
    
    public override func setupForTransparent() {
        super.setupForTransparent()
        setting.setupForTransparent()
    }
    
    private let primitive: ShaderPrimitive<Vertex>
}
