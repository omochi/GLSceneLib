public class EventSourceFlatMapLatest<TSource: EventSourceProtocol, USource: EventSourceProtocol> : EventSourceProtocol {
    public typealias T = TSource.Event
    public typealias U = USource.Event
    
    public init(_ source: TSource, _ f: @escaping (T) -> USource) {
        self.source = source
        self.f = f
    }
    
    public func addHandler(_ handler: @escaping (U) -> ()) -> Disposer {
        let sink = Sink(f, handler)
        return source.addHandler { sink.send($0) }
    }
    
    private class Sink {
        public init(_ f: @escaping (T) -> USource,
                    _ handler: @escaping (U) -> Void)
        {
            self.cd = .init()
            self.f = f
            self.handler = handler
        }
        
        public func send(_ t: T) {
            let uSource: USource = f(t)
            cd.dispose()
            cd.add(uSource.addHandler { [handler] (u: U) in
                handler(u)
            })
        }
        
        private let cd: CompositeDisposer
        private let f: (T) -> USource
        private let handler: (U) -> Void
    }
    
    private let source: TSource
    private let f: (T) -> USource
}

public extension EventSourceProtocol {
    func flatMapLatest<USource: EventSourceProtocol>(_ f: @escaping (Event) -> USource) -> EventSource<USource.Event> {
        return EventSourceFlatMapLatest(self, f).asEventSource()
    }
}
