public class Light : SceneElement {
    public var color: OpaqueColor = .init(white: 1)
    public var ambientFactor: Float = 0
    
    public override init() {
        super.init()
        
        sharable = false
        renderable = false
    }
    
    public override func onAddToScene(_ scene: Scene) {
        scene.addElementToLookupTable(key: .light, element: self)
    }
    
    public override func onRemoveFromScene(_ scene: Scene) {
        scene.removeElementFromLookupTable(key: .light, element: self)
    }
}
