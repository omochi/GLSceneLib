#if os(iOS)
    import OpenGLES
#else
    import OpenGL.GL3
#endif

public class GLShader {
    public init(vertexShaderSource: String,
                fragmentShaderSource: String) throws
    {
        let vsh = GLIDHolder(id: GL.createShader(GLenum(GL_VERTEX_SHADER))) {
            GL.deleteShader($0)
        }
        GL.shaderSource(vsh.id, [vertexShaderSource])
        if GL.compileShader(vsh.id) != GL_TRUE {
            let log = GL.getShaderInfoLog(vsh.id)
            throw GenericError(message: "vertex shader compile failed: log=\n\(log)")
        }
        self.vertexShaderIDHolder = vsh
        self.vertexShaderSource = vertexShaderSource
        
        let fsh = GLIDHolder(id: GL.createShader(GLenum(GL_FRAGMENT_SHADER))) {
            GL.deleteShader($0)
        }
        GL.shaderSource(fsh.id, [fragmentShaderSource])
        if GL.compileShader(fsh.id) != GL_TRUE {
            let log = GL.getShaderInfoLog(fsh.id)
            throw GenericError(message: "fragment shader compile failed: log=\n\(log)")
        }
        self.fragmentShaderIDHolder = fsh
        self.fragmentShaderSource = fragmentShaderSource
        
        let program = GLIDHolder(id: GL.createProgram()) {
            GL.deleteProgram($0)
        }
        GL.attachShader(program.id, vsh.id)
        GL.attachShader(program.id, fsh.id)
        if GL.linkProgram(program.id) != GL_TRUE {
            let log = GL.getProgramInfoLog(program.id)
            throw GenericError(message: "link program failed: log=\n\(log)")
        }
        self.programIDHolder = program
    }
    
    public let vertexShaderIDHolder: GLIDHolder
    public let vertexShaderSource: String
    public let fragmentShaderIDHolder: GLIDHolder
    public let fragmentShaderSource: String
    public let programIDHolder: GLIDHolder
    public var id: GLuint {
        return programIDHolder.id
    }
    
    public var uniformLocationCache: [String: GLint] = [:]
    public var attributeLocationCache: [String: GLint] = [:]
    
    public func use() {
        GL.useProgram(id)
    }
    
    public func unuse() {
        GL.useProgram(0)
    }
    
    public func setUniform1(name: String, value: [GLfloat]) {
        if let location = getUniformLocationOrNone(name: name) {
            GL.uniform1(location, value)
        }
    }
    
    public func setUniform2(name: String, value: [GLfloat]) {
        if let location = getUniformLocationOrNone(name: name) {
            GL.uniform2(location, value)
        }
    }
    
    public func setUniform3(name: String, value: [GLfloat]) {
        if let location = getUniformLocationOrNone(name: name) {
            GL.uniform3(location, value)
        }
    }
    
    public func setUniform4(name: String, value: [GLfloat]) {
        if let location = getUniformLocationOrNone(name: name) {
            GL.uniform4(location, value)
        }
    }
    
    public func setUniformMatrix4(name: String, transpose: Bool, value: [GLfloat]) {
        if let location = getUniformLocationOrNone(name: name) {
            let transpose = GLboolean(transpose)
            GL.uniformMatrix4(location, transpose, value)
        }
    }
    
    public func setUniform(name: String, value: Float) {
        setUniform1(name: name, value: [GLfloat(value)])
    }
    
    public func setUniform(name: String, value: Vector2) {
        setUniform2(name: name, value: value.toGL())
    }
    
    public func setUniform(name: String, value: Vector3) {
        setUniform3(name: name, value: value.toGL())
    }
    
    public func setUniform(name: String, value: Vector4) {
        setUniform4(name: name, value: value.toGL())
    }
    
    public func setUniform(name: String, value: Matrix4x4) {
        setUniformMatrix4(name: name, transpose: false, value: value.toGL())
    }
    
    public func getUniformLocationOrNone(name: String) -> GLuint? {
        let location: GLint
        if let cache = uniformLocationCache[name] {
            location = cache
        } else {
            location = GL.getUniformLocation(id, name)
            uniformLocationCache[name] = location
        }
        return location >= 0 ? GLuint(location) : nil
    }
    
    public func getUniformLocation(name: String) throws -> GLuint {
        guard let loc = getUniformLocationOrNone(name: name) else {
            throw GenericError(message: "uniform not found: \(name)")
        }
        return loc
    }
    
    public func getAttributeLocationOrNone(name: String) -> GLuint? {
        let location: GLint
        if let cache = attributeLocationCache[name] {
            location = cache
        } else {
            location = GL.getAttribLocation(id, name)
            attributeLocationCache[name] = location
        }
        return location >= 0 ? GLuint(location) : nil
    }
    
    public func getAttributeLocation(name: String) throws -> GLuint {
        guard let loc = getAttributeLocationOrNone(name: name) else {
            throw GenericError(message: "attribute not found: \(name)")
        }
        return loc
    }
    
}

