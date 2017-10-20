#if os(iOS)
    import OpenGLES
#else
    import OpenGL.GL3
#endif

public extension GLboolean {
    public init(_ bool: Bool) {
        self.init(bool ? GL_TRUE : GL_FALSE)
    }
}
