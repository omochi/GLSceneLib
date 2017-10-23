public class EventSourceCombineArray<TSource: EventSourceProtocol> : EventSourceProtocol {
    public typealias T = TSource.Event
    
    public init(_ tSourceArray: [TSource]) {
        self.tSourceArray = tSourceArray
    }
    
    public func addHandler(_ handler: @escaping ([T]) -> ()) -> Disposer {
        var tArray: [T?] = Array.init(repeating: nil, count: tSourceArray.count)
        
        func emit(at index: Int, t: T) {
            tArray[index] = t
            if let tArray = tArray as? [T] {
                handler(tArray)
            }
        }
        
        let cd = CompositeDisposer()
        for (index, tSource) in tSourceArray.enumerated() {
            cd.add(tSource.addHandler { (t: T) in
                emit(at: index, t: t)
            })
        }
        
        return cd.asDisposer()
    }
    
    private let tSourceArray: [TSource]
}

public func combine<TSource: EventSourceProtocol>(_ tSourceArray: [TSource]) -> EventSource<[TSource.Event]> {
    return EventSourceCombineArray(tSourceArray).asEventSource()
}

