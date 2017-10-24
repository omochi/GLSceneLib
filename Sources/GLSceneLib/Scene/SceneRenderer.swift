#if os(iOS)
    import OpenGLES
#else
    import OpenGL.GL3
#endif

public class SceneRenderer {
    public struct RenderElement {
        var node: SceneNode
        var element: SceneElement
        
        func render(renderer: SceneRenderer) {
            element.render(with: renderer, node: node)
        }
    }
    
    public init() {
        colorShader = ColorShader()
        colorLineShader = ColorLineShader()
        phongShader = PhongShader()
    }
    
    public var scene: Scene {
        get {
            return assertNotNone("scene") { _scene }
        }
        set {
            _scene = newValue
        }
    }
    
    public private(set) var colorShader: ColorShader
    public private(set) var colorLineShader: ColorLineShader
    public private(set) var phongShader: PhongShader
    
    public private(set) var viewing: Matrix4x4 = .identity
    public private(set) var projection: Matrix4x4 = .identity
    public private(set) var viewportSize: Size = Size()
    
    // ndc to viewport
    // viewport: origin=top left
    public var viewportTransform: Matrix4x4 {
        let vw = viewportSize.width
        let vh = viewportSize.height
        return Matrix4x4.scaling(Vector3(vw / 2.0, -vh / 2.0, 1)) *
            Matrix4x4.translation(Vector3(vw / 2.0, vh / 2.0, 0))
    }

    public func createTextRenderer() -> TextRenderer? {
        return scene.createTextRenderer?()
    }
    
    public func render(scene: Scene) {
        scene.rootNode.updateWorldTransform()
        
        if let clearColor = scene.clearColor {
            GL.clearColor(clearColor.red, clearColor.green, clearColor.blue, clearColor.alpha)
            GL.clear(GLbitfield(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT | GL_STENCIL_BUFFER_BIT))
        }
        
        let display = scene.display
        self.viewportSize = display.size
    
        GL.viewport(0, 0,
                    GLsizei(viewportSize.width * display.pixelRatio),
                    GLsizei(viewportSize.height * display.pixelRatio))
        
        scene.backgroundRenderer?()
        
        guard let camera = scene.camera else {
            scene.warning("camera is none")
            return
        }
        guard let cameraNode = camera.nodes.first else {
            scene.warning("camera node is none")
            return
        }
        
        self.viewing = cameraNode.worldTransform.inverted()
        self.projection = camera.projeciton(width: viewportSize.width, height: viewportSize.height)
        
        let lights = scene.findLights()
        
        setBasicTransformToShader(colorShader)
        setBasicTransformToShader(colorLineShader)
        colorLineShader.viewportSize = self.viewportSize
        setBasicTransformToShader(phongShader)
        phongShader.lights = lights

        var elements: [RenderElement] = collectRenderElements(scene: scene)
        
        let opaqueElements = elements.filter { !$0.element.transparent }
        let transparentElements = elements.filter { $0.element.transparent }
        
        elements = opaqueElements + transparentElements
        
        elements.forEach { element in
            element.render(renderer: self)
        }
    }
    
    private func collectRenderElements(scene: Scene) -> [RenderElement] {
        var result = [RenderElement]()
        collectRenderElements(node: scene.rootNode, result: &result)
        return result
    }
    
    private func collectRenderElements(node: SceneNode, result: inout [RenderElement]) {        
        let elements: [SceneElement] = node.elements.filter { $0.renderable }
        let renderElements: [RenderElement] = elements.map { RenderElement(node: node, element: $0) }
        result.append(contentsOf: renderElements)
        
        for child in node.children {
            collectRenderElements(node: child, result: &result)
        }
    }
    
    private func setBasicTransformToShader<X: BasicTransformShaderProtocol>(_ shader: X) {
        shader.viewing = self.viewing
        shader.projection = self.projection
    }

    private weak var _scene: Scene?
}

