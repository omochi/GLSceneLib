public class EventSourceMerge<TSource: EventSourceProtocol> : EventSourceProtocol {
    public typealias T = TSource.Event
    
    public init(_ tSourceArray: [TSource]) {
        self.tSourceArray = tSourceArray
    }
    
    public func addHandler(_ handler: @escaping (T) -> ()) -> Disposer {
        let sink = Sink(handler)
        
        let cd = CompositeDisposer()
        for tSource in tSourceArray {
            cd.add(tSource.addHandler { sink.send($0) })
        }
        return cd.asDisposer()
    }
    
    public class Sink {
        public init(_ handler: @escaping (T) -> ()) {
            self.handler = handler
        }
        
        public func send(_ t: T) {
            handler(t)
        }
        
        private let handler: (T) -> Void
    }
    
    private let tSourceArray: [TSource]
}

public func merge<TSource: EventSourceProtocol>(_ tSourceArray: [TSource]) -> EventSource<TSource.Event> {
    return EventSourceMerge(tSourceArray).asEventSource()
}

