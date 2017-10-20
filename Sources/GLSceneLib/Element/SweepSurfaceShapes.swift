import Foundation

public extension SweepSurface {
    static func createCircle(radius: Float,
                             splitNum: Int,
                             z: Float) -> SweepSurface {
        var ret = SweepSurface()
        
        let color = Color(white: 1.0, alpha: 1.0)
        
        let n = splitNum
        let angleStep = 2 * Float.pi / Float(n)
        for i in 0..<n {
            let angle = angleStep * Float(i)
            let pos = Vector3(cos(angle), sin(angle), z) * radius
            let normal = Vector3(cos(angle), sin(angle), 0)
            
            ret.addVertex(.init(position: pos,
                                normal: normal,
                                color: color))
        }
        
        ret.edges = (0..<n).map { i in
            Edge(point0: i, point1: (i + 1) % n) }
        
        return ret
    }
    
    static func createRect(center: Vector2,
                           size: Vector2,
                           z: Float) -> SweepSurface
    {
        var ret = SweepSurface()
        
        let color = Color(white: 1.0, alpha: 1.0)
        
        let p0 = center + Vector2(-size.x, +size.y) / 2.0
        let p1 = center + Vector2(-size.x, -size.y) / 2.0
        let p2 = center + Vector2(+size.x, -size.y) / 2.0
        let p3 = center + Vector2(+size.x, +size.y) / 2.0
        
        ret.addVertex(.init(position: p0.to3(z: z),
                            normal: Vector3(-1, 0, 0),
                            color: color))
        ret.addVertex(.init(position: p1.to3(z: z),
                            normal: Vector3(-1, 0, 0),
                            color: color))
        
        ret.addVertex(.init(position: p1.to3(z: z),
                            normal: Vector3(0, -1, 0),
                            color: color))
        ret.addVertex(.init(position: p2.to3(z: z),
                            normal: Vector3(0, -1, 0),
                            color: color))
        
        ret.addVertex(.init(position: p2.to3(z: z),
                            normal: Vector3(1, 0, 0),
                            color: color))
        ret.addVertex(.init(position: p3.to3(z: z),
                            normal: Vector3(1, 0, 0),
                            color: color))
        
        ret.addVertex(.init(position: p3.to3(z: z),
                            normal: Vector3(0, 1, 0),
                            color: color))
        ret.addVertex(.init(position: p0.to3(z: z),
                            normal: Vector3(0, 1, 0),
                            color: color))
        
        ret.edges.append(.init(point0: 0, point1: 1))
        ret.edges.append(.init(point0: 2, point1: 3))
        ret.edges.append(.init(point0: 4, point1: 5))
        ret.edges.append(.init(point0: 6, point1: 7))
        
        return ret
    }
}

