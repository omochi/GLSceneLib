import Foundation
import DebugReflect

public struct Matrix4x4 : CustomStringConvertible, DebugReflectable {
    public init() {}
    
    public init(_ e00: Float, _ e01: Float, _ e02: Float, _ e03: Float,
                _ e10: Float, _ e11: Float, _ e12: Float, _ e13: Float,
                _ e20: Float, _ e21: Float, _ e22: Float, _ e23: Float,
                _ e30: Float, _ e31: Float, _ e32: Float, _ e33: Float)
    {
        self.e00 = e00; self.e01 = e01; self.e02 = e02; self.e03 = e03
        self.e10 = e10; self.e11 = e11; self.e12 = e12; self.e13 = e13
        self.e20 = e20; self.e21 = e21; self.e22 = e22; self.e23 = e23
        self.e30 = e30; self.e31 = e31; self.e32 = e32; self.e33 = e33
    }
    
    public init(elements: [Float]) {
        self.elements = elements
    }
    
    public var e00: Float = 0
    public var e01: Float = 0
    public var e02: Float = 0
    public var e03: Float = 0
    public var e10: Float = 0
    public var e11: Float = 0
    public var e12: Float = 0
    public var e13: Float = 0
    public var e20: Float = 0
    public var e21: Float = 0
    public var e22: Float = 0
    public var e23: Float = 0
    public var e30: Float = 0
    public var e31: Float = 0
    public var e32: Float = 0
    public var e33: Float = 0
    
    public var description: String {
        return """
        Matrix4x4(\(e00), \(e01), \(e02), \(e03),
        \(e10), \(e11), \(e12), \(e13),
        \(e20), \(e21), \(e22), \(e23),
        \(e30), \(e31), \(e32), \(e33))
        """
    }
    
    public func debugReflect() -> DebugReflectValue {
        return .string(description)
    }
    
    public var elements: [Float] {
        get {
            return [
                e00, e01, e02, e03,
                e10, e11, e12, e13,
                e20, e21, e22, e23,
                e30, e31, e32, e33]
        }
        set {
            e00 = newValue[0]
            e01 = newValue[1]
            e02 = newValue[2]
            e03 = newValue[3]
            e10 = newValue[4]
            e11 = newValue[5]
            e12 = newValue[6]
            e13 = newValue[7]
            e20 = newValue[8]
            e21 = newValue[9]
            e22 = newValue[10]
            e23 = newValue[11]
            e30 = newValue[12]
            e31 = newValue[13]
            e32 = newValue[14]
            e33 = newValue[15]
        }
    }
    
    public subscript (_ index: Int) -> Float {
        get {
            switch index {
            case 0: return e00
            case 1: return e01
            case 2: return e02
            case 3: return e03
            case 4: return e10
            case 5: return e11
            case 6: return e12
            case 7: return e13
            case 8: return e20
            case 9: return e21
            case 10: return e22
            case 11: return e23
            case 12: return e30
            case 13: return e31
            case 14: return e32
            case 15: return e33
            default:
                fatalError("invalid index: \(index)")
            }
        }
        set (x) {
            switch index {
            case 0: e00 = x; break
            case 1: e01 = x; break
            case 2: e02 = x; break
            case 3: e03 = x; break
            case 4: e10 = x; break
            case 5: e11 = x; break
            case 6: e12 = x; break
            case 7: e13 = x; break
            case 8: e20 = x; break
            case 9: e21 = x; break
            case 10: e22 = x; break
            case 11: e23 = x; break
            case 12: e30 = x; break
            case 13: e31 = x; break
            case 14: e32 = x; break
            case 15: e33 = x; break
            default:
                fatalError("invalid index: \(index)")
            }
        }
    }
    
    public subscript (_ row: Int, _ column: Int) -> Float {
        get {
            return self[row * 4 + column]
        }
        set (x) {
            self[row * 4 + column] = x
        }
    }
    
    public func getDeterminant() -> Float {
        let a = e00, b = e01, c = e02, d = e03
        let e = e10, f = e11, g = e12, h = e13
        let i = e20, j = e21, k = e22, l = e23
        let m = e30, n = e31, o = e32, p = e33
        
        let kp_lo = k * p - l * o
        let jp_ln = j * p - l * n
        let jo_kn = j * o - k * n
        let ip_lm = i * p - l * m
        let io_km = i * o - k * m
        let in_jm = i * n - j * m
        
        return a * (f * kp_lo - g * jp_ln + h * jo_kn) -
            b * (e * kp_lo - g * ip_lm + h * io_km) +
            c * (e * jp_ln - f * ip_lm + h * in_jm) -
            d * (e * jo_kn - f * io_km + g * in_jm)
    }
    
    public mutating func transpose() {
        swap(&e01, &e10)
        swap(&e02, &e20)
        swap(&e03, &e30)
        swap(&e12, &e21)
        swap(&e13, &e31)
        swap(&e23, &e32)
    }
    
    public func transposed() -> Matrix4x4 {
        var ret = self
        ret.transpose()
        return ret
    }
    
    public mutating func invert() {
        let a = e00, b = e01, c = e02, d = e03
        let e = e10, f = e11, g = e12, h = e13
        let i = e20, j = e21, k = e22, l = e23
        let m = e30, n = e31, o = e32, p = e33
        
        let kp_lo = k * p - l * o
        let jp_ln = j * p - l * n
        let jo_kn = j * o - k * n
        let ip_lm = i * p - l * m
        let io_km = i * o - k * m
        let in_jm = i * n - j * m
        
        let a00 = +(f * kp_lo - g * jp_ln + h * jo_kn)
        let a01 = -(e * kp_lo - g * ip_lm + h * io_km)
        let a02 = +(e * jp_ln - f * ip_lm + h * in_jm)
        let a03 = -(e * jo_kn - f * io_km + g * in_jm)
        
        let det = a * a00 + b * a01 + c * a02 + d * a03
        
        precondition(det != 0, "determinant != 0")
        
        let invDet = 1.0 / det;
        
        e00 = a00 * invDet
        e10 = a01 * invDet
        e20 = a02 * invDet
        e30 = a03 * invDet
        
        e01 = -(b * kp_lo - c * jp_ln + d * jo_kn) * invDet
        e11 = +(a * kp_lo - c * ip_lm + d * io_km) * invDet
        e21 = -(a * jp_ln - b * ip_lm + d * in_jm) * invDet
        e31 = +(a * jo_kn - b * io_km + c * in_jm) * invDet
        
        let gp_ho = g * p - h * o
        let fp_hn = f * p - h * n
        let fo_gn = f * o - g * n
        let ep_hm = e * p - h * m
        let eo_gm = e * o - g * m
        let en_fm = e * n - f * m
        
        e02 = +(b * gp_ho - c * fp_hn + d * fo_gn) * invDet
        e12 = -(a * gp_ho - c * ep_hm + d * eo_gm) * invDet
        e22 = +(a * fp_hn - b * ep_hm + d * en_fm) * invDet
        e32 = -(a * fo_gn - b * eo_gm + c * en_fm) * invDet
        
        let gl_hk = g * l - h * k
        let fl_hj = f * l - h * j
        let fk_gj = f * k - g * j
        let el_hi = e * l - h * i
        let ek_gi = e * k - g * i
        let ej_fi = e * j - f * i
        
        e03 = -(b * gl_hk - c * fl_hj + d * fk_gj) * invDet
        e13 = +(a * gl_hk - c * el_hi + d * ek_gi) * invDet
        e23 = -(a * fl_hj - b * el_hi + d * ej_fi) * invDet
        e33 = +(a * fk_gj - b * ek_gi + c * ej_fi) * invDet
    }
    
    public func inverted() -> Matrix4x4 {
        var ret = self
        ret.invert()
        return ret
    }
    
    public static var identity: Matrix4x4 {
        return Matrix4x4(
            1, 0, 0, 0,
            0, 1, 0, 0,
            0, 0, 1, 0,
            0, 0, 0, 1)
    }
    
    public static func translation(_ t: Vector3) -> Matrix4x4 {
        return Matrix4x4(
            1, 0, 0, 0,
            0, 1, 0, 0,
            0, 0, 1, 0,
            t.x, t.y, t.z, 1)
    }
    
    public static func rotationX(_ angle: Float) -> Matrix4x4 {
        let s = sin(angle)
        let c = cos(angle)
        return Matrix4x4(
            1, 0, 0, 0,
            0, c, s, 0,
            0, -s, c, 0,
            0, 0, 0, 1)
    }
    
    public static func rotationY(_ angle: Float) -> Matrix4x4 {
        let s = sin(angle)
        let c = cos(angle)
        return Matrix4x4(
            c, 0, -s, 0,
            0, 1, 0, 0,
            s, 0, c, 0,
            0, 0, 0, 1)
    }
    
    public static func rotationZ(_ angle: Float) -> Matrix4x4 {
        let s = sin(angle)
        let c = cos(angle)
        return Matrix4x4(
            c, s, 0, 0,
            -s, c, 0, 0,
            0, 0, 1, 0,
            0, 0, 0, 1)
    }
    
    public static func scaling(_ s: Vector3) -> Matrix4x4 {
        return Matrix4x4(
            s.x, 0, 0, 0,
            0, s.y, 0, 0,
            0, 0, s.z, 0,
            0, 0, 0, 1)
    }
    
    public static func ortho(
        left: Float, right: Float,
        bottom: Float, top: Float,
        near: Float, far: Float) -> Matrix4x4
    {
        let w = right - left
        let h = top - bottom
        let a = 2 / w
        let b = 2 / h
        let c = -2 / (far - near)
        let tx = -(right + left) / w
        let ty = -(top + bottom) / h
        let tz = -(far + near) / (far - near)
        return Matrix4x4(
            a, 0, 0, 0,
            0, b, 0, 0,
            0, 0, c, 0,
            tx, ty, tz, 1)
    }
    
    public static func frustum(
        left: Float, right: Float,
        bottom: Float, top: Float,
        near: Float, far: Float) -> Matrix4x4
    {
        let w = right - left
        let h = top - bottom
        let a = (right + left) / w
        let b = (top + bottom) / h
        let c = -(far + near) / (far - near)
        let d = -(2 * far * near) / (far - near)
        let sx = 2 * near / w
        let sy = 2 * near / h
        return Matrix4x4(
            sx,  0,  0,  0,
            0, sy,  0,  0,
            a,  b,  c, -1,
            0,  0,  d,  0)
    }
    
    public static func cameraFrustum(
        width: Float, height: Float,
        fov: Float,
        near: Float, far: Float) -> Matrix4x4
    {
        let nh = near * 2.0 * tan(fov / 2.0)
        let nw = nh * width / height
        return frustum(
            left: -nw / 2.0, right: nw / 2.0,
            bottom: -nh / 2.0, top: nh / 2.0,
            near: near, far: far)
    }
}

public func * (a: Float, b: Matrix4x4) -> Matrix4x4 {
    return Matrix4x4(
        a * b.e00, a * b.e01, a * b.e02, a * b.e03,
        a * b.e10, a * b.e11, a * b.e12, a * b.e13,
        a * b.e20, a * b.e21, a * b.e22, a * b.e23,
        a * b.e30, a * b.e31, a * b.e32, a * b.e33
    )
}

public func / (a: Matrix4x4, b: Float) -> Matrix4x4 {
    return (1.0 / b) * a
}

public func /= (a: inout Matrix4x4, b: Float) {
    a = a / b
}

public func * (a: Vector4, b: Matrix4x4) -> Vector4 {
    let x = a.x * b.e00 + a.y * b.e10 + a.z * b.e20 + a.w * b.e30
    let y = a.x * b.e01 + a.y * b.e11 + a.z * b.e21 + a.w * b.e31
    let z = a.x * b.e02 + a.y * b.e12 + a.z * b.e22 + a.w * b.e32
    let w = a.x * b.e03 + a.y * b.e13 + a.z * b.e23 + a.w * b.e33
    return Vector4(x, y, z, w)
}

public func * (a: Matrix4x4, b: Matrix4x4) -> Matrix4x4 {
    let e00 = a.e00 * b.e00 + a.e01 * b.e10 + a.e02 * b.e20 + a.e03 * b.e30
    let e01 = a.e00 * b.e01 + a.e01 * b.e11 + a.e02 * b.e21 + a.e03 * b.e31
    let e02 = a.e00 * b.e02 + a.e01 * b.e12 + a.e02 * b.e22 + a.e03 * b.e32
    let e03 = a.e00 * b.e03 + a.e01 * b.e13 + a.e02 * b.e23 + a.e03 * b.e33
    let e10 = a.e10 * b.e00 + a.e11 * b.e10 + a.e12 * b.e20 + a.e13 * b.e30
    let e11 = a.e10 * b.e01 + a.e11 * b.e11 + a.e12 * b.e21 + a.e13 * b.e31
    let e12 = a.e10 * b.e02 + a.e11 * b.e12 + a.e12 * b.e22 + a.e13 * b.e32
    let e13 = a.e10 * b.e03 + a.e11 * b.e13 + a.e12 * b.e23 + a.e13 * b.e33
    let e20 = a.e20 * b.e00 + a.e21 * b.e10 + a.e22 * b.e20 + a.e23 * b.e30
    let e21 = a.e20 * b.e01 + a.e21 * b.e11 + a.e22 * b.e21 + a.e23 * b.e31
    let e22 = a.e20 * b.e02 + a.e21 * b.e12 + a.e22 * b.e22 + a.e23 * b.e32
    let e23 = a.e20 * b.e03 + a.e21 * b.e13 + a.e22 * b.e23 + a.e23 * b.e33
    let e30 = a.e30 * b.e00 + a.e31 * b.e10 + a.e32 * b.e20 + a.e33 * b.e30
    let e31 = a.e30 * b.e01 + a.e31 * b.e11 + a.e32 * b.e21 + a.e33 * b.e31
    let e32 = a.e30 * b.e02 + a.e31 * b.e12 + a.e32 * b.e22 + a.e33 * b.e32
    let e33 = a.e30 * b.e03 + a.e31 * b.e13 + a.e32 * b.e23 + a.e33 * b.e33
    return Matrix4x4(
        e00, e01, e02, e03,
        e10, e11, e12, e13,
        e20, e21, e22, e23,
        e30, e31, e32, e33)
}

public func *= (a: inout Matrix4x4, b: Matrix4x4) {
    a = a * b
}




