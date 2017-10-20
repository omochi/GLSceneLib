#if os(iOS)
    import OpenGLES
#else
    import OpenGL.GL3
#endif

public class GLVertexArray {
    public init() {
        idHolder = GLIDHolder(id: GL.genVertexArrays(1)[0]) {
            GL.deleteVertexArrays([$0])
        }
    }
    
    public let idHolder: GLIDHolder
    public var id: GLuint {
        return idHolder.id
    }
    
    public func bind() {
        GL.bindVertexArray(id)
    }
    
    public func unbind() {
        GL.bindVertexArray(0)
    }
    
    public func enableAttribute(location: GLuint) {
        guard location >= 0 else {
            return
        }
        GL.enableVertexAttribArray(location)
    }
    
    public func disableAttribute(location: GLuint) {
        guard location >= 0 else {
            return
        }
        GL.disableVertexAttribArray(location)
    }
    
    public func setAttributePointer(location: GLuint,
                                    size: Int,
                                    type: GLenum,
                                    normalized: Bool,
                                    stride: Int,
                                    ptr: UnsafeRawPointer?)
    {
        guard location >= 0 else {
            return
        }
        GL.vertexAttribPointer(location,
                               GLint(size),
                               type,
                               GLboolean(normalized),
                               GLsizei(stride),
                               ptr)
    }
    
    public func draw(mode: GLenum,
                     count: Int,
                     type: GLenum)
    {
        GL.drawElements(mode, GLsizei(count), type, UnsafeRawPointer(bitPattern: 0))
    }
    
}
