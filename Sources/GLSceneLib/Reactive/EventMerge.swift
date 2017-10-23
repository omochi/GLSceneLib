public class EventSourceMerge<TSource: EventSourceProtocol> : EventSourceProtocol {
    public typealias T = TSource.Event
    
    public init(_ tSourceArray: [TSource]) {
        self.tSourceArray = tSourceArray
    }
    
    public func addHandler(_ handler: @escaping (T) -> ()) -> Disposer {
        func emit(t: T) {
            handler(t)
        }
        
        let cd = CompositeDisposer()
        for tSource in tSourceArray {
            cd.add(tSource.addHandler { (t: T) in
                emit(t: t)
            })
        }
        return cd.asDisposer()
    }
    
    private let tSourceArray: [TSource]
}

public func merge<TSource: EventSourceProtocol>(_ tSourceArray: [TSource]) -> EventSource<TSource.Event> {
    return EventSourceMerge(tSourceArray).asEventSource()
}
