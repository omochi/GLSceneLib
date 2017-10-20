public protocol BasicTransformShaderProtocol : ShaderProtocol {
    var modeling: Matrix4x4 { get set }
    var viewing: Matrix4x4 { get set }
    var projection: Matrix4x4 { get set }
}

