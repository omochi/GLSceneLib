public struct ExtrudeSolid {
    public init() {}
    
    public var vertices: [SweepSurface.Vertex] = []
    
    public var topFace: SweepSurface.Face = .init()
    public var sideFaces: [SweepSurface.Face] = []
    public var bottomFace: SweepSurface.Face = .init()
    
    public var allFaces: [SweepSurface.Face] {
        return [topFace] + sideFaces + [bottomFace]
    }
    
    public func createMesh() -> MeshElement {
        let ret = MeshElement()
        ret.vertices = vertices.enumerated().map { (i, vertex) in
            MeshElement.Vertex(position: vertex.position,
                               normal: vertex.normal,
                               color: vertex.color)
        }
        ret.indices = allFaces.flatMap { face in face.points }
        return ret
    }
}
