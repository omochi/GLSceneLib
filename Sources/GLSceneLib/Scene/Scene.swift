#if os(iOS)
    import UIKit
#endif

public class Scene {
    public enum ElementLookupKey {
        case light
    }
    
    public init() {
        rootNode = SceneNode()
        
        renderer = SceneRenderer()
        
        rootNode._setScene(self)
        renderer.scene = self
        
        clearColor = Color(white: 0, alpha: 1)
    }
    
    public private(set) var rootNode: SceneNode
    
    public var clearColor: Color?
    public var backgroundRenderer: (() -> Void)?
    
    public var camera: Camera?
    
    #if os(iOS)
    public func setViewSpec(view: UIView) {
        guard let camera = camera else {
            fatalError("camera is nil")
        }
        camera.setViewSpec(view: view)
    }
    #endif
    
    public func render() {
        renderer.render()
    }
    
    public func findLights() -> [Light] {
        return elementsForLookupKey(key: .light) as! [Light]
    }
    
    public func addElementToLookupTable(key: ElementLookupKey, element: SceneElement) {
        var elements = elementsForLookupKey(key: key)
        elements.append(element)
        elementLookupTable[key] = elements
    }
    
    public func removeElementFromLookupTable(key: ElementLookupKey, element: SceneElement) {
        var elements = elementsForLookupKey(key: key)
        elements.remove { $0 === element }
        elementLookupTable[key] = elements
    }
    
    public func elementsForLookupKey(key: ElementLookupKey) -> [SceneElement] {
        if let elements = elementLookupTable[key] {
            return elements
        } else {
            let elements = [SceneElement]()
            elementLookupTable[key] = elements
            return elements
        }
    }
    
    private var elementLookupTable: [ElementLookupKey: [SceneElement]] = [:]
    private let renderer: SceneRenderer
}

