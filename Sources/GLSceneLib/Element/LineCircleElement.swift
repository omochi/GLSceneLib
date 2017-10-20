
public class LineCircleElement : SceneElement, BasicSceneElementProtocol {
    public override init() {
        circle = ColorLineCirclePrimitive()
        super.init()
    }
    
    public var center: Vector3 {
        get {
            return circle.center
        }
        set {
            circle.center = newValue
        }
    }
    
    public var radius: Float {
        get {
            return circle.radius
        }
        set {
            circle.radius = newValue
        }
    }
    
    public var splitNum: Int {
        get {
            return circle.splitNum
        }
        set {
            circle.splitNum = newValue
        }
    }
    
    public var lineWidth: Float {
        get {
            return circle.lineWidth
        }
        set {
            circle.lineWidth = newValue
        }
    }
    
    public var color: Color {
        get {
            return circle.color
        }
        set {
            circle.color = newValue
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
        
        let shader = renderer.colorLineShader
        
        setting.apply()
        shader.modeling = node.worldTransform
        shader.draw(primitive: circle)
        setting.clear()
    }
    
    public override func setupForTransparent() {
        super.setupForTransparent()
        setting.setupForTransparent()
    }
    
    private let circle: ColorLineCirclePrimitive
}

