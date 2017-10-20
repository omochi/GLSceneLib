public class DirectionalLight : Light {
    public var direction: Vector3 = .init(0, 0, 1)
    
    public override init() {}
    
    public init(direction: Vector3,
                color: OpaqueColor,
                ambientFactor: Float)
    {
        self.direction = direction
        super.init()
        self.color = color
        self.ambientFactor = ambientFactor
    }
}
