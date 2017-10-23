public class EventSourceMap<X: EventSourceProtocol, U> : EventSourceProtocol {
    public init(_ source: X, _ f: @escaping (X.Event) -> U) {
        self.source = source
        self.f = f
    }

    public func addHandler(_ handler: @escaping (U) -> ()) -> Disposer {
        let disposer = source.addHandler { [weak self] (t: X.Event) in
            guard let zelf = self else {
                return
            }
            let u = zelf.f(t)
            handler(u)
        }
        return disposer
    }
    
    private let source: X
    private let f: (X.Event) -> U
}

extension EventSourceProtocol {
    public func map<U>(_ f: @escaping (Event) -> U) -> EventSource<U> {
        return EventSourceMap(self, f).asEventSource()
    }
}

