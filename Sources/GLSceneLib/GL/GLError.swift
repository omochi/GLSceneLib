#if os(iOS)
    import OpenGLES
#else
    import OpenGL.GL3
#endif

public struct GLError : Error, CustomStringConvertible {
    public init(function: String,
                codes: [GLenum])
    {
        self.function = function
        self.codes = codes
    }
    
    public var function: String
    public var codes: [GLenum]
    
    public var description: String {
        let codeStr = codes
            .map { code in
                String(format: "%@(0x%04x)", GL.errorCodeToString(code), code)
            }.joined(separator: ", ")
        return String(format: "GLError(function: %@, code=%@)",
                      function, codeStr)
    }
    
    public static func getLast(function: String) -> GLError? {
        let codes = GL.getErrorCodes()
        if codes.count > 0 {
            return GLError(function: function, codes: codes)
        } else {
            return nil
        }
    }
}

public func assertNoGLError(_ function: String) {
    guard let error = GLError.getLast(function: function) else {
        return
    }

    fatalError(String(describing: error))
}

