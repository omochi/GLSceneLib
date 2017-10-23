public protocol EventSourceProtocol {
    associatedtype Event
    
    func addHandler(_ handler: @escaping (Event) -> ()) -> Disposer
}

extension EventSourceProtocol {
    public func asEventSource() -> EventSource<Event> {
        return EventSource<Event>(self)
    }
}

public class EventSource<Event> : EventSourceProtocol {
    public init<X: EventSourceProtocol> (_ base: X)
        where X.Event == Event
    {
        self._addHandler = { base.addHandler($0) }
    }
    
    public init(_ addHandler: @escaping (@escaping (Event) -> ()) -> Disposer) {
        self._addHandler = addHandler
    }
    
    public func addHandler(_ handler: @escaping (Event) -> ()) -> Disposer {
        return _addHandler(handler)
    }
    
    private let _addHandler: (@escaping (Event) -> ()) -> Disposer
}

extension EventSource {
    public static func of(_ x: Event) -> EventSource<Event> {
        return Property<Event>(x).asEventSource()
    }
    
    public static func never() -> EventSource<Event> {
        return EventSource.init { handler in
            Disposer {}
        }
    }
}
