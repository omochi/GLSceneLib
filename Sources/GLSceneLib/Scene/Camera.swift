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
    
    public var fovY: Float = toRadian(60)
    public var nearClipZ: Float = 0.1
    public var farClipZ: Float = 1000.0
    
    public func projeciton(width: Float, height: Float) -> Matrix4x4 {
        return Matrix4x4.cameraFrustum(width: width,
                                       height: height,
                                       fov: fovY,
                                       near: nearClipZ,
                                       far: farClipZ)
    }
}

