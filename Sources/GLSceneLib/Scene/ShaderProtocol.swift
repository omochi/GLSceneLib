public protocol ShaderProtocol : class {
    var attributeDefinition: VertexAttributeDefinition { get }
    var glShader: GLShader { get }
}

