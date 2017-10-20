#if os(iOS)
    import OpenGLES
#else
    import OpenGL.GL3
#endif

public class GLIDHolder {
    public init(id: GLuint, deleter: @escaping (GLuint) -> Void) {
        self.id = id
        self.deleter = deleter
    }
    
    deinit {
        deleter(id)
    }
    
    public let id: GLuint
    public let deleter: (GLuint) -> Void
}

