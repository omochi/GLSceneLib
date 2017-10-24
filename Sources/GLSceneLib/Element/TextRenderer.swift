public protocol TextRenderer : class {
    func updateVisible(_ value: Bool)
    func updateText(_ value: String)
    func updateColor(_ value: Color)
    func render(position: Vector3,
                renderer: SceneRenderer)
}

