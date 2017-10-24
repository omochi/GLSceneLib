#if os(iOS)
    import UIKit
#endif

import CoreGraphics

public class Scene {
    public enum ElementLookupKey {
        case light
    }
    
    public init() {
        _rootNode = SceneNode()
        _renderer = SceneRenderer()
        display = Display()
        clearColor = Color(white: 0, alpha: 1)
       
        //

        _renderer.scene = self
        _rootNode._setScene(self)
    }
    
    public var rootNode: SceneNode {
        return _rootNode
    }

    public var display: Display
    public var camera: Camera?

    public var clearColor: Color?
    public var backgroundRenderer: (() -> Void)?
    public var createTextRenderer: (() -> TextRenderer)?
    
    #if os(iOS)
    public func setViewSpec(view: UIView) {
        display.size = Size(view.bounds.size)
        display.pixelRatio = Float(view.contentScaleFactor)
    }
    #endif
    
    public func render() {
        _renderer.render(scene: self)
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
    
    public func warning(_ message: String) {
        print("[warn] \(message)")
    }
    
    private var elementLookupTable: [ElementLookupKey: [SceneElement]] = [:]
    
    private let _renderer: SceneRenderer
    private let _rootNode: SceneNode
}

