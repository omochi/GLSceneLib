open class SceneElement : SceneElementProtocol {
    public init() {}
    
    public private(set) var nodes: [SceneNode] {
        get {
            return _nodes.unboxedElements
        }
        set {
            _nodes.unboxedElements = newValue
        }
    }
    
    public var scene: Scene? {
        return _scene
    }
    
    public var sharable: Bool = true
    public var renderable: Bool = true
    public var transparent: Bool = false
    
    open func render(with renderer: SceneRenderer,
                     node: SceneNode)
    {
        fatalError("unimplemented")
    }
    
    public func setupForTransparent() {
        transparent = true
    }
    
    public func onAddToScene(_ scene: Scene) { }
    
    public func onRemoveFromScene(_ scene: Scene) { }
    
    public func _addNode(_ node: SceneNode) {
        if !sharable {
            if nodes.count >= 1 {
                fatalError("this elements is not sharable")
            }
        }
        
        nodes.append(node)
        _setScene(node.scene)
    }
    
    public func _removeNode(_ node: SceneNode) {
        nodes.remove { $0 === node }
        _setScene(nil)
    }
    
    public func _setScene(_ scene: Scene?) {
        if let scene = scene {
            let allEqual = nodes.testAll { $0.scene.map { $0 === scene } ?? true }
            if !allEqual {
                fatalError("element scene conflict")
            }
            __setScene(scene)
        } else {
            if (nodes.testAll { $0.scene == nil }) {
                __setScene(nil)
            }
        }
    }
    
    private func __setScene(_ scene: Scene?) {
        let change = !(optionalEquals(self._scene, scene) { $0 === $1 })
        
        if change {
            if let oldScene = self._scene {
                onRemoveFromScene(oldScene)
            }
        }
        
        self._scene = scene
        
        if change {
            if let scene = scene {
                onAddToScene(scene)
            }
        }
    }
    
    private var _nodes: [WeakBox<SceneNode>] = []
    private weak var _scene: Scene?
}

