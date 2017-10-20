#if os(iOS)
    import UIKit
#endif

/*
 camera looks at (0, 0, -1)
 */
public class Camera : SceneElement {
    public override init() {
        super.init()
        sharable = false
        renderable = false
    }
    
    public var viewportSize: Size = Size()
    public var pixelRatio: Float = 1
    public var fovY: Float = toRadian(60)
    public var nearClipZ: Float = 0.1
    public var farClipZ: Float = 1000.0
    
    public var projection: Matrix4x4 {
        return Matrix4x4.cameraFrustum(width: viewportSize.width,
                                       height: viewportSize.height,
                                       fov: fovY,
                                       near: nearClipZ,
                                       far: farClipZ)
    }
    
    #if os(iOS)
    public func setViewSpec(view: UIView) {
        viewportSize = Size(view.bounds.size)
        pixelRatio = Float(view.contentScaleFactor)
    }
    #endif
}

