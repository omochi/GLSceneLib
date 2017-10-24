public protocol SceneElementProtocol : class {
    var nodes: [SceneNode] { get }
    var scene: Scene? { get }
    var sharable: Bool { get set }
    var renderable: Bool { get set }
    var transparent: Bool { get set }
    func render(with renderer: SceneRenderer,
                node: SceneNode)
    func setupForTransparent()
}

public protocol SettingPropertySceneElementProtocol : SceneElementProtocol {
    var setting: RenderSetting { get set }
}

public protocol VisiblePropertySceneElementProtocol : SceneElementProtocol {
    var visible: Bool { get set }
}
