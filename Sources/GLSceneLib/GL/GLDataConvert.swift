#if os(iOS)
    import OpenGLES
#else
    import OpenGL.GL3
#endif

extension Vector2 {
    public func toGL() -> [GLfloat] {
        return elements.map { GLfloat($0) }
    }
}

extension Vector3 {
    public func toGL() -> [GLfloat] {
        return elements.map { GLfloat($0) }
    }
}

extension Vector4 {
    public func toGL() -> [GLfloat] {
        return elements.map { GLfloat($0) }
    }
}

extension Matrix4x4 {
    public func toGL() -> [GLfloat] {
        return elements.map { GLfloat($0) }
    }
}

