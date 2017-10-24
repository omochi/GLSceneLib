public class TextElement : SceneElement,
    VisiblePropertySceneElementProtocol
{
    public override init()
    {
        visible = true
        rendererVisible = visible
        
        super.init()
    }
    
    public var visible: Bool {
        didSet {
            rendererVisible = visible
        }
    }
    
    public var text: String = "" {
        didSet {
            renderer?.updateText(text)
        }
    }
    
    public var color: Color = Color(white: 0.7, alpha: 1.0) {
        didSet {
            renderer?.updateColor(color)
        }
    }
    
    public var position: Vector3 = Vector3()

    public override func render(with sr: SceneRenderer,
                                node: SceneNode)
    {
        guard visible else {
            return
        }
        
        let ndcPosition = position.transformedIn3D(node.worldTransform * sr.viewing * sr.projection)
        
        guard -1.0 < ndcPosition.z && ndcPosition.z < 1.0  else {
            rendererVisible = false
            return
        }
        
        let viewportPosition = ndcPosition.transformedIn3D(sr.viewportTransform)
        
        if !rendererVisible {
            rendererVisible = true
        }
        
        if self.renderer == nil {
            self.renderer = sr.createTextRenderer()
        }
        guard let renderer = self.renderer else {
            return
        }
        
        renderer.render(position: viewportPosition, renderer: sr)
    }
    
    private var renderer: TextRenderer? {
        didSet {
            text = run { text }
            color = run { color }
            rendererVisible = run { rendererVisible }
        }
    }
    
    private var rendererVisible: Bool {
        didSet {
            renderer?.updateVisible(rendererVisible)
        }
    }
    
    
}
