#if os(iOS)
    import OpenGLES
#else
    import OpenGL.GL3
#endif

public struct RenderSetting {
    public init() {}
    
    public var depthTestEnabled: Bool = true
    public var depthFunc: GLenum = GLenum(GL_LEQUAL)
    public var depthMask: Bool = true
    
    public var blendEnabled: Bool = false
    public var blendFuncSourceFactor = GLenum(GL_SRC_ALPHA)
    public var blendFuncDestFactor = GLenum(GL_ONE_MINUS_SRC_ALPHA)
    
    public var cullFace: GLenum = GLenum(GL_BACK)
    
    public func apply() {
        if depthTestEnabled {
            GL.enable(GLenum(GL_DEPTH_TEST))
            GL.depthFunc(depthFunc)
        } else {
            GL.disable(GLenum(GL_DEPTH_TEST))
        }
        
        GL.depthMask(GLboolean(depthMask))
        
        if blendEnabled {
            GL.enable(GLenum(GL_BLEND))
            GL.blendFunc(blendFuncSourceFactor, blendFuncDestFactor)
        }
        
        GL.enable(GLenum(GL_CULL_FACE))
        GL.cullFace(cullFace)
    }
    
    public func clear() {
        GL.disable(GLenum(GL_DEPTH_TEST))
        GL.depthMask(GLboolean(true))
        GL.disable(GLenum(GL_BLEND))
        GL.disable(GLenum(GL_CULL_FACE))
    }
    
    public mutating func setupForTransparent() {
        blendEnabled = true
        blendFuncSourceFactor = GLenum(GL_SRC_ALPHA)
        blendFuncDestFactor = GLenum(GL_ONE_MINUS_SRC_ALPHA)
        depthMask = false
    }
}

