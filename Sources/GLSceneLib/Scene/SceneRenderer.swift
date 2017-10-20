#if os(iOS)
    import OpenGLES
#else
    import OpenGL.GL3
#endif

public class SceneRenderer {
    public struct RenderElement {
        var node: SceneNode
        var element: SceneElement
    }
    
    public init() {
        colorShader = ColorShader()
        colorLineShader = ColorLineShader()
        phongShader = PhongShader()
    }
    
    public weak var scene: Scene?
    
    public private(set) var colorShader: ColorShader
    public private(set) var colorLineShader: ColorLineShader
    public private(set) var phongShader: PhongShader
    
    public private(set) var viewing: Matrix4x4 = .identity
    public private(set) var projection: Matrix4x4 = .identity
    public private(set) var viewportSize: Size = Size()
    
    public func getViewportTransform() -> Matrix4x4 {
        let vw = viewportSize.width
        let vh = viewportSize.height
        return Matrix4x4.scaling(Vector3(vw / 2.0, vh / 2.0, 1.0)) *
            Matrix4x4.translation(Vector3(vw / 2.0, vh / 2.0, 0))
    }
    
    public func render() {
        guard let scene = scene else {
            fatalError("scene is nil")
        }
        
        scene.rootNode.updateWorldTransform()
        
        guard let camera = scene.camera else {
            fatalError("camera is nil")
        }
        guard let cameraNode = camera.nodes.first else {
            fatalError("camera node is nil")
        }
        self.viewing = cameraNode.worldTransform.inverted()
        self.projection = camera.projection
        self.viewportSize = camera.viewportSize
        
        setBasicTransformToShader(colorShader)
        setBasicTransformToShader(colorLineShader)
        colorLineShader.viewportSize = self.viewportSize
        setBasicTransformToShader(phongShader)
        
        let lights = scene.findLights()
        phongShader.lights = lights
        
        if let clearColor = scene.clearColor {
            GL.clearColor(clearColor.red, clearColor.green, clearColor.blue, clearColor.alpha)
            GL.clear(GLbitfield(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT | GL_STENCIL_BUFFER_BIT))
        }
        
        GL.viewport(0, 0,
                    GLsizei(camera.viewportSize.width * camera.pixelRatio),
                    GLsizei(camera.viewportSize.height * camera.pixelRatio))
        
        scene.backgroundRenderer?()
        
        renderElements.removeAll(keepingCapacity: true)
        collectRenderElements(scene: scene, result: &renderElements)
        
        renderElements.sort { a, b in
            if a.element.transparent != b.element.transparent {
                return !a.element.transparent
            }
            return false
        }
        
        for e in renderElements {
            e.element.render(with: self, node: e.node)
        }
    }
    
    public func collectRenderElements(scene: Scene, result: inout [RenderElement]) {
        collectRenderElements(node: scene.rootNode, result: &result)
    }
    
    public func collectRenderElements(node: SceneNode, result: inout [RenderElement]) {
        for element in node.elements {
            if element.renderable {
                result.append(RenderElement(node: node, element: element))
            }
        }
        
        for child in node.children {
            collectRenderElements(node: child, result: &result)
        }
    }
    
    private func setBasicTransformToShader<X: BasicTransformShaderProtocol>(_ shader: X) {
        shader.viewing = self.viewing
        shader.projection = self.projection
    }
    
    private var renderElements: [RenderElement] = []
}

