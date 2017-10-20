public struct GenericError : Error, CustomStringConvertible {
    public init(message: String) {
        self.message = message
    }
    
    public init(message: String, causer: Error) {
        self.message = message
        self.causer = causer
    }

    public var message: String
    public var causer: Error?

    public var description: String {
        var str = "GenericError(\(message))"
        
        if let causer = causer {
            str += " causer ->\n" + String(describing: causer)
        }

        return str
    }
    
    public static func wrapError<R>(message: String, _ f: () throws -> R) rethrows -> R {
        do {
            return try f()
        } catch let e {
            throw GenericError(message: message, causer: e)
        }
    }
}
