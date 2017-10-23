public class EventSourceMap<TSource: EventSourceProtocol, U> : EventSourceProtocol {
    public typealias T = TSource.Event

    public init(_ source: TSource, _ f: @escaping (T) -> U) {
        self.source = source
        self.f = f
    }

    public func addHandler(_ handler: @escaping (U) -> ()) -> Disposer {
        let disposer = source.addHandler { [weak self] (t: T) in
            guard let zelf = self else {
                return
            }
            let u = zelf.f(t)
            handler(u)
        }
        return disposer
    }
    
    private let source: TSource
    private let f: (T) -> U
}

extension EventSourceProtocol {
    public func map<U>(_ f: @escaping (Event) -> U) -> EventSource<U> {
        return EventSourceMap(self, f).asEventSource()
    }
}

