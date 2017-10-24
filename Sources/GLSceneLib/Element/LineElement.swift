public class LineElement : SceneElement,
    SettingPropertySceneElementProtocol,
    VisiblePropertySceneElementProtocol
{
    public override init() {
        line = ColorLinePrimitive()
        super.init()
    }
    
    public var points: [Vector3] {
        get {
            return line.points
        }
        set {
            line.points = newValue
        }
    }
    
    public var closed: Bool {
        get {
            return line.closed
        }
        set {
            line.closed = newValue
        }
    }
    
    public var color: Color {
        get {
            return line.color
        }
        set {
            line.color = newValue
        }
    }
    
    public var width: Float {
        get {
            return line.width
        }
        set {
            line.width = newValue
        }
    }
    
    public var setting: RenderSetting = RenderSetting()
    
    public var visible: Bool = true
    
    public override func render(with renderer: SceneRenderer,
                                node: SceneNode)
    {
        guard visible else {
            return
        }
        
        setting.apply()
        
        let shader = renderer.colorLineShader
        shader.modeling = node.worldTransform
        shader.draw(primitive: line)
        setting.clear()
    }
    
    public override func setupForTransparent() {
        super.setupForTransparent()
        setting.setupForTransparent()
    }
    
    private var line: ColorLinePrimitive
}

