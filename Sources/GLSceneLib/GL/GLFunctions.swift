#if os(iOS)
    import OpenGLES
#else
    import OpenGL.GL3
#endif

public enum GL {
    public static func getErrorCodes() -> [GLenum] {
        var result = [GLenum]()
        while true {
            let code = glGetError()
            if code == GL_NO_ERROR {
                break
            }
            result.append(code)
        }
        return result
    }
    
    public static func errorCodeToString(_ code: GLenum) -> String {
        switch Int32(code) {
        case GL_INVALID_ENUM:
            return "GL_INVALID_ENUM"
        case GL_INVALID_VALUE:
            return "GL_INVALID_VALUE"
        case GL_INVALID_OPERATION:
            return "GL_INVALID_OPERATION"
        case GL_OUT_OF_MEMORY:
            return "GL_OUT_OF_MEMORY"
        default:
            return "unknown(\(code))"
        }
    }
    
    public static func clearColor(_ red: GLfloat, _ green: GLfloat, _ blue: GLfloat, _ alpha: GLfloat) {
        glClearColor(red, green, blue, alpha)
        assertNoGLError("glClearColor")
    }
    
    public static func clear(_ mask: GLbitfield) {
        glClear(mask)
        assertNoGLError("glClear")
    }
    
    public static func viewport(_ x: GLint, _ y: GLint, _ width: GLsizei, _ height: GLsizei) {
        glViewport(x, y, width, height)
        assertNoGLError("glViewport")
    }
    
    public static func enable(_ cap: GLenum) {
        glEnable(cap)
        assertNoGLError("glEnable")
    }
    
    public static func disable(_ cap: GLenum) {
        glDisable(cap)
        assertNoGLError("glDisable")
    }
    
    public static func depthFunc(_ fun: GLenum) {
        glDepthFunc(fun)
        assertNoGLError("glDepthFunc")
    }
    
    public static func depthMask(_ flag: GLboolean) {
        glDepthMask(flag)
        assertNoGLError("glDepthMask")
    }
    
    public static func blendFunc(_ s: GLenum, _ d: GLenum) {
        glBlendFunc(s, d)
        assertNoGLError("glBlendFunc")
    }
    
    public static func cullFace(_ face: GLenum) {
        glCullFace(face)
        assertNoGLError("glCullFace")
    }
    
    public static func createShader(_ type: GLenum) -> GLuint {
        let id = glCreateShader(type)
        assertNoGLError("glCreateShader")
        return id
    }
    
    public static func deleteShader(_ id: GLuint) {
        glDeleteShader(id)
        assertNoGLError("glDeleteShader")
    }
    
    public static func getShaderi(_ id: GLuint,
                                  _ name: GLenum) -> GLint
    {
        var ret = GLint()
        getShaderiv(id, name, &ret)
        return ret
    }
    
    public static func getShaderiv(_ id: GLuint,
                                   _ name: GLenum,
                                   _ params: UnsafeMutablePointer<GLint>?)
    {
        glGetShaderiv(id, name, params)
        assertNoGLError("glGetShaderiv")
    }
    
    public static func getShaderInfoLog(_ id: GLuint) -> String {
        let len = Int(getShaderi(id, GLenum(GL_INFO_LOG_LENGTH)))
        var glString = getShaderInfoLog(id, GLsizei(len))
        glString.append(0)
        return String(cString: glString)
    }
    
    public static func getShaderInfoLog(_ id: GLuint,
                                        _ maxLength: GLsizei) -> Array<GLchar>
    {
        var log = Array<GLchar>(repeating: 0, count: Int(maxLength))
        var len = GLsizei()
        getShaderInfoLog(id, maxLength, &len, &log)
        log.removeLast(log.count - Int(len))
        return log
    }
    
    public static func getShaderInfoLog(_ id: GLuint,
                                        _ maxLength: GLsizei,
                                        _ length: UnsafeMutablePointer<GLsizei>?,
                                        _ infoLog: UnsafeMutablePointer<GLchar>?)
    {
        glGetShaderInfoLog(id, maxLength, length, infoLog)
        assertNoGLError("glGetShaderInfoLog")
    }
    
    public static func shaderSource(_ id: GLuint,
                                    _ strings: Array<String>)
    {
        let glStrings = strings.map { (string: String) -> Array<GLchar> in
            string.utf8CString.map { GLchar($0) }
        }
        shaderSource(id, glStrings)
    }
    
    public static func shaderSource(_ id: GLuint,
                                    _ strings: Array<Array<GLchar>>)
    {
        strings.withUnsafeBufferPointerArray { (buffers: Array<UnsafeBufferPointer<GLchar>>) in
            shaderSource(id,
                         GLsizei(buffers.count),
                         buffers.map { $0.baseAddress },
                         buffers.map { GLint($0.count) })
        }
    }
    
    public static func shaderSource(_ id: GLuint,
                                    _ count: GLsizei,
                                    _ strings: UnsafePointer<UnsafePointer<GLchar>?>?,
                                    _ lengths: UnsafePointer<GLint>?)
    {
        glShaderSource(id, count, strings, lengths)
        assertNoGLError("glShaderSource")
    }
    
    public static func compileShader(_ id: GLuint) -> GLint {
        glCompileShader(id)
        assertNoGLError("glCompileShader")
        return getShaderi(id, GLenum(GL_COMPILE_STATUS))
    }
    
    public static func createProgram() -> GLuint {
        let id = glCreateProgram()
        assertNoGLError("glCreateProgram")
        return id
    }
    
    public static func deleteProgram(_ id: GLuint) {
        glDeleteProgram(id)
        assertNoGLError("glDeleteProgram")
    }
    
    public static func getProgrami(_ id: GLuint, _ name: GLenum) -> GLint {
        var ret = GLint()
        getProgramiv(id, name, &ret)
        return ret
    }
    
    public static func getProgramiv(_ id: GLuint, _ name: GLenum,
                                    _ params: UnsafeMutablePointer<GLint>?)
    {
        glGetProgramiv(id, name, params)
        assertNoGLError("glGetProgramiv")
    }
    
    public static func getProgramInfoLog(_ id: GLuint) -> String {
        let len = Int(getProgrami(id, GLenum(GL_INFO_LOG_LENGTH))) + 1
        var glString = getProgramInfoLog(id, GLsizei(len))
        glString.append(0)
        return String(cString: glString)
    }
    
    public static func getProgramInfoLog(_ id: GLuint,
                                         _ maxLength: GLsizei) -> Array<GLchar>
    {
        var log = Array<GLchar>(repeating: 0, count: Int(maxLength))
        var len = GLsizei()
        getProgramInfoLog(id, maxLength, &len, &log)
        log.removeLast(log.count - Int(len))
        return log
    }
    
    public static func getProgramInfoLog(_ id: GLuint,
                                         _ maxLength: GLsizei,
                                         _ length: UnsafeMutablePointer<GLsizei>?,
                                         _ infoLog: UnsafeMutablePointer<GLchar>?)
    {
        glGetProgramInfoLog(id, maxLength, length, infoLog)
        assertNoGLError("glGetProgramInfoLog")
    }
    
    public static func attachShader(_ id: GLuint, _ shader: GLuint) {
        glAttachShader(id, shader)
        assertNoGLError("glAttachShader")
    }
    
    public static func linkProgram(_ id: GLuint) -> GLint {
        glLinkProgram(id)
        assertNoGLError("glLinkProgram")
        return getProgrami(id, GLenum(GL_LINK_STATUS))
    }
    
    public static func useProgram(_ id: GLuint) {
        glUseProgram(id)
        assertNoGLError("glUseProgram")
    }
    
    public static func getAttribLocation(_ id: GLuint, _ name: String) -> GLint {
        let ret = name.utf8CString.withUnsafeBufferPointer { mem in
            glGetAttribLocation(id, mem.baseAddress)
        }
        assertNoGLError("glGetAttribLocation")
        return ret
    }
    
    public static func getUniformLocation(_ id: GLuint, _ name: String) -> GLint {
        let ret = name.utf8CString.withUnsafeBufferPointer { mem in
            glGetUniformLocation(id, mem.baseAddress)
        }
        assertNoGLError("glGetUniformLocation")
        return ret
    }
    
    public static func uniform1(_ location: GLuint, _ values: [GLfloat]) {
        glUniform1fv(GLint(location), GLsizei(values.count), values)
        assertNoGLError("glUniform1fv")
    }
    
    public static func uniform2(_ location: GLuint, _ values: [GLfloat]) {
        glUniform2fv(GLint(location), GLsizei(values.count / 2), values)
        assertNoGLError("glUniform2fv")
    }
    
    public static func uniform3(_ location: GLuint, _ values: [GLfloat]) {
        glUniform3fv(GLint(location), GLsizei(values.count / 3), values)
        assertNoGLError("glUniform3fv")
    }
    
    public static func uniform4(_ location: GLuint, _ values: [GLfloat]) {
        glUniform4fv(GLint(location), GLsizei(values.count / 4), values)
        assertNoGLError("glUniform4fv")
    }
    
    public static func uniformMatrix4(_ location: GLuint, _ transpose: GLboolean, _ values: [GLfloat]) {
        glUniformMatrix4fv(GLint(location), GLsizei(values.count / 16), transpose, values)
        assertNoGLError("glUniformMatrix4fv")
    }
    
    public static func genBuffers(_ n: Int) -> [GLuint] {
        var ids = Array<GLuint>(repeating: 0, count: n)
        glGenBuffers(GLsizei(n), &ids)
        assertNoGLError("GLGenBuffers")
        return ids
    }
    
    public static func deleteBuffers(_ ids: [GLuint]) {
        var ids = ids
        glDeleteBuffers(GLsizei(ids.count), &ids)
        assertNoGLError("GLDeleteBuffers")
    }
    
    public static func bindBuffer(_ target: GLenum, _ id: GLuint) {
        glBindBuffer(target, id)
        assertNoGLError("glBindBuffer")
    }
    
    public static func bufferData(_ target: GLenum, _ size: GLsizeiptr,
                                  _ data: UnsafeRawPointer?, _ usage: GLenum) {
        glBufferData(target, size, data, usage)
        assertNoGLError("glBufferData")
    }
    
    public static func genVertexArrays(_ n: Int) -> [GLuint] {
        var ids = Array<GLuint>(repeating: 0, count: n)
        glGenVertexArrays(GLsizei(n), &ids)
        assertNoGLError("glGenVertexArrays")
        return ids
    }
    
    public static func deleteVertexArrays(_ ids: [GLuint]) {
        var ids = ids
        glDeleteVertexArrays(GLsizei(ids.count), &ids)
        assertNoGLError("glDeleteVertexArrays")
    }
    
    public static func bindVertexArray(_ id: GLuint) {
        glBindVertexArray(id)
        assertNoGLError("glBindVertexArray")
    }
    
    public static func enableVertexAttribArray(_ location: GLuint) {
        glEnableVertexAttribArray(location)
        assertNoGLError("glEnableVertexAttribArray")
    }
    
    public static func disableVertexAttribArray(_ location: GLuint) {
        glDisableVertexAttribArray(location)
        assertNoGLError("glDisableVertexAttribArray")
    }
    
    public static func vertexAttribPointer(_ location: GLuint,
                                           _ size: GLint,
                                           _ type: GLenum,
                                           _ normalized: GLboolean,
                                           _ stride: GLsizei,
                                           _ ptr: UnsafeRawPointer?)
    {
        glVertexAttribPointer(location, size, type, normalized, stride, ptr)
        assertNoGLError("glVertexAttribPointer")
    }
    
    public static func drawElements(_ mode: GLenum,
                                    _ count: GLsizei,
                                    _ type: GLenum,
                                    _ indices: UnsafeRawPointer?)
    {
        glDrawElements(mode, count, type, indices)
        assertNoGLError("glDrawElements")
    }
    
}

