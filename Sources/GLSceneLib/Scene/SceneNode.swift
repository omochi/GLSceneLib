open class SceneNode {
    public init() {}
    
    public convenience init(element: SceneElement) {
        self.init()
        addElement(element)
    }
    
    deinit {
        deinitEvent.emit(())
    }
    
    public let deinitEvent = EventEmitter<Void>()
    
    public private(set) weak var scene: Scene?
    public private(set) weak var parent: SceneNode?
    public private(set) var children: [SceneNode] = []
    public private(set) var elements: [SceneElement] = []
    
    public var transform: Matrix4x4 = Matrix4x4.identity
    
    public private(set) var worldTransform: Matrix4x4 = Matrix4x4.identity
    
    public func clear() {
        removeAllChildren()
        removeAllElements()
    }
    
    public func addChild(_ node: SceneNode) {
        guard node.parent == nil else {
            fatalError("already has parent")
        }
        children.append(node)
        node._setParent(self)
    }
    
    public func removeChild(_ node: SceneNode) {
        if let index = (children.index { $0 === node }) {
            removeChild(at: index)
        }
    }
    
    public func removeChild(at index: Int) {
        let node = children[index]
        children.remove(at: index)
        node._setParent(nil)
    }
    
    public func removeAllChildren() {
        while children.count > 0 {
            removeChild(at: children.count - 1)
        }
    }
    
    public func addElement(_ element: SceneElement) {
        guard !(element.nodes.contains { $0 === element }) else {
            fatalError("already belongs this node")
        }
        
        elements.append(element)
        element._addNode(self)
    }
    
    public func removeElement(_ element: SceneElement) {
        if let index = (elements.index { $0 === element }) {
            removeElement(at: index)
        }
    }
    
    public func removeElement(at index: Int) {
        let elem = elements[index]
        elements.remove(at: index)
        elem._removeNode(self)
    }
    
    public func removeAllElements() {
        while elements.count > 0 {
            removeElement(at: elements.count - 1)
        }
    }
    
    public func removeFromParent() {
        parent?.removeChild(self)
    }
    
    public func updateWorldTransform() {
        updateWorldTransform(parentTransform: Matrix4x4.identity)
    }
    
    public func updateWorldTransform(parentTransform: Matrix4x4) {
        worldTransform = transform * parentTransform
        
        for child in children {
            child.updateWorldTransform(parentTransform: worldTransform)
        }
    }
    
    public func _setParent(_ parent: SceneNode?) {
        let changeScene: Bool = !(optionalEquals(self.scene, parent?.scene) { $0 === $1 })
        
        if changeScene {
            _setScene(nil)
        }
        self.parent = parent
        if changeScene {
            _setScene(parent?.scene)
        }
    }
    
    public func _setScene(_ scene: Scene?) {
        _setScene_node(scene)
        _setScene_elements(scene)
    }
    
    private func _setScene_node(_ scene: Scene?) {
        self.scene = scene
        children.forEach { child in
            child._setScene_node(scene)
        }
    }
    
    private func _setScene_elements(_ scene: Scene?) {
        elements.forEach { element in
            element._setScene(scene)
        }
        children.forEach { child in
            child._setScene_elements(scene)
        }
    }
}
