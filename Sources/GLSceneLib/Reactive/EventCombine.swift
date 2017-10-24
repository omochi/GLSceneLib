public class EventSourceCombineArray<TSource: EventSourceProtocol> : EventSourceProtocol {
    public typealias T = TSource.Event
    
    public init(_ tSourceArray: [TSource]) {
        self.tSourceArray = tSourceArray
    }
    
    public func addHandler(_ handler: @escaping ([T]) -> ()) -> Disposer {
        let sink = Sink(tSourceArray.count, handler)
        
        let cd = CompositeDisposer()
        for (index, tSource) in tSourceArray.enumerated() {
            cd.add(tSource.addHandler { sink.send(at: index, $0) })
        }
        
        return cd.asDisposer()
    }
    
    private class Sink {
        public init(_ count: Int, _ handler: @escaping ([T]) -> ()) {
            tArray = .init(repeating: nil, count: count)
            self.handler = handler
        }
        
        public func send(at index: Int, _ t: T) {
            tArray[index] = t
            if let tArray = tArray as? [T] {
                handler(tArray)
            }
        }
        
        private var tArray: [T?]
        private let handler: ([T]) -> ()
    }
    
    private let tSourceArray: [TSource]
}

public func combine<TSource: EventSourceProtocol>(_ tSourceArray: [TSource]) -> EventSource<[TSource.Event]> {
    return EventSourceCombineArray(tSourceArray).asEventSource()
}

