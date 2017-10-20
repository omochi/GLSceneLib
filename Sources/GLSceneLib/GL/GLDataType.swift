#if os(iOS)
    import OpenGLES
#else
    import OpenGL.GL3
#endif

public protocol GLDataType {
    static func toGLenum() -> GLenum
    
    func write(to: UnsafeMutableRawPointer)
}

public extension GLDataType {
    func write(to: UnsafeMutableRawPointer) {
        var x = self
        to.copyBytes(from: &x, count: MemoryLayout<Self>.size)
    }
}

extension GLfloat: GLDataType {
    public static func toGLenum() -> GLenum {
        return GLenum(GL_FLOAT)
    }
}

extension GLushort: GLDataType {
    public static func toGLenum() -> GLenum {
        return GLenum(GL_UNSIGNED_SHORT)
    }
}

