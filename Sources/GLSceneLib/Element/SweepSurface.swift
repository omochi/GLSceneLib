public struct SweepSurface {
    public typealias Vertex = PhongShader.Vertex
    
    public struct Edge {
        public var point0: Int
        public var point1: Int
        
        public init(point0: Int, point1: Int) {
            self.point0 = point0
            self.point1 = point1
        }
    }
    
    public struct Triangle {
        public var point0: Int
        public var point1: Int
        public var point2: Int
        
        public init(point0: Int, point1: Int, point2: Int) {
            self.point0 = point0
            self.point1 = point1
            self.point2 = point2
        }
        
        public init(points: [Int]) {
            self.init(point0: points[0], point1: points[1], point2: points[2])
        }
        
        public var points: [Int] {
            return [point0, point1, point2]
        }
        
        public func reversed() -> Triangle {
            return Triangle(point0: point0, point1: point2, point2: point1)
        }
    }
    
    public struct Face {
        public var triangles: [Triangle] = []
        
        public init() {}
        
        public init(triangles: [Triangle]) {
            self.triangles = triangles
        }
        
        public var points: [Int] {
            return triangles.flatMap { $0.points }
        }
        
        public func reversed() -> Face {
            return Face(triangles: triangles.map { $0.reversed() })
        }
    }
    
    public init() {}
    
    public var vertices: [Vertex] = []
    public var edges: [Edge] = []
    
    public var vertexNum: Int {
        return vertices.count
    }
    
    public mutating func addVertex(_ v: Vertex) {
        vertices.append(v)
    }
    
    public func createSurfaceFace() -> Face {
        let triangles = (0..<edges.count - 2).map { i in
            SweepSurface.Triangle(point0: edges[0].point0,
                                  point1: edges[i].point1,
                                  point2: edges[i + 1].point1)
        }
        return Face(triangles: triangles)
    }
    
    public func extrude(direction: Vector3, length: Float) -> ExtrudeSolid {
        var ret = ExtrudeSolid()
        
        let topFaceVerticesStartIndex = ret.vertices.count
        let topFaceVertices: [Vertex] = vertices.map { (v) -> Vertex in
            return .init(position: v.position + direction * length,
                         normal: Vector3(0, 0, 1),
                         color: v.color)
        }
        ret.vertices.append(contentsOf: topFaceVertices)
        
        ret.topFace = apply(createSurfaceFace()) {
            Face(triangles: $0.triangles.map { triangle in
                Triangle(points: triangle.points.map { $0 + topFaceVerticesStartIndex })
            })
        }
        
        let bottomFaceVerticesStartIndex = ret.vertices.count
        let bottomFaceVertices: [Vertex] = vertices.map { (v) -> Vertex in
            return .init(position: v.position,
                         normal: Vector3(0, 0, -1),
                         color: v.color)
        }
        ret.vertices.append(contentsOf: bottomFaceVertices)
        
        ret.bottomFace = apply(createSurfaceFace()) {
            Face(triangles: $0.triangles.map { triangle in
                Triangle(points: triangle.points.map { $0 + bottomFaceVerticesStartIndex })
            }).reversed()
        }
        
        let sideFaceTopVerticesStartIndex = ret.vertices.count
        let sideFaceTopVertices: [Vertex] = vertices.map { (v) -> Vertex in
            return .init(position: v.position + direction * length,
                         normal: v.normal,
                         color: v.color)
        }
        ret.vertices.append(contentsOf: sideFaceTopVertices)
        
        let sideFaceBottomVerticesStartIndex = ret.vertices.count
        let sideFaceBottomVertices: [Vertex] = vertices.map { (v) -> Vertex in
            return .init(position: v.position,
                         normal: v.normal,
                         color: v.color)
        }
        ret.vertices.append(contentsOf: sideFaceBottomVertices)
        
        ret.sideFaces = edges.map { (edge) -> Face in
            let tri0 = Triangle(point0: sideFaceBottomVerticesStartIndex + edge.point0,
                                point1: sideFaceBottomVerticesStartIndex + edge.point1,
                                point2: sideFaceTopVerticesStartIndex + edge.point1)
            let tri1 = Triangle(point0: sideFaceTopVerticesStartIndex + edge.point1,
                                point1: sideFaceTopVerticesStartIndex + edge.point0,
                                point2: sideFaceBottomVerticesStartIndex + edge.point0)
            return Face(triangles: [tri0, tri1])
        }
        
        return ret
    }
}
