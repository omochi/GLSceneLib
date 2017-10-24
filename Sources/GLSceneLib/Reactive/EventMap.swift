public class EventSourceMap<TSource: EventSourceProtocol, U> : EventSourceProtocol {
    public typealias T = TSource.Event

    public init(_ source: TSource, _ f: @escaping (T) -> U) {
        self.source = source
        self.f = f
    }

    public func addHandler(_ handler: @escaping (U) -> ()) -> Disposer {
        let sink = Sink(f, handler)
        return source.addHandler { sink.send($0) }
    }
    
    private class Sink {
        public init(
            _ f: @escaping (T) -> U,
            _ handler: @escaping (U) -> Void)
        {
            self.f = { (t: T) in
                let u: U = f(t)
                handler(u)
            }
        }
        
        public func send(_ t: T) {
            f(t)
        }
        
        private let f: (T) -> Void
    }
    
    private let source: TSource
    private let f: (T) -> U
}

extension EventSourceProtocol {
    public func map<U>(_ f: @escaping (Event) -> U) -> EventSource<U> {
        return EventSourceMap(self, f).asEventSource()
    }
}

