#if os(iOS)
    import OpenGLES
#else
    import OpenGL.GL3
#endif

public class GLBuffer {
    public enum Target {
        case vertex
        case index
        
        public func toGLenum() -> GLenum {
            switch self {
            case .vertex:
                return GLenum(GL_ARRAY_BUFFER)
            case .index:
                return GLenum(GL_ELEMENT_ARRAY_BUFFER)
            }
        }
    }
    
    public init(target: Target) {
        self.target = target
        self.idHolder = GLIDHolder(id: GL.genBuffers(1)[0]) {
            GL.deleteBuffers([$0])
        }
    }
    
    public var target: Target
    public var usage: GLenum = GLenum(GL_STATIC_DRAW)
    public let idHolder: GLIDHolder
    public var id: GLuint {
        return idHolder.id
    }
    
    public func bind() {
        GL.bindBuffer(target.toGLenum(), id)
    }
    
    public func unbind() {
        GL.bindBuffer(target.toGLenum(), 0)
    }
    
    public func setData(pointer: UnsafeRawPointer?, size: Int)
    {
        GL.bufferData(target.toGLenum(), GLsizeiptr(size), pointer, usage)
    }
}

