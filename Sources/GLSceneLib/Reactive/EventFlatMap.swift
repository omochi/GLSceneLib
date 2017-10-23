public class EventSourceFlatMapLatest<TSource: EventSourceProtocol, USource: EventSourceProtocol> : EventSourceProtocol {
    public typealias T = TSource.Event
    public typealias U = USource.Event
    
    public init(_ source: TSource, _ f: @escaping (T) -> USource) {
        self.source = source
        self.f = f
    }
    
    public func addHandler(_ handler: @escaping (U) -> ()) -> Disposer {
        let cd = CompositeDisposer()
        let disposer = source.addHandler { [weak self] (t: T) in
            guard let zelf = self else {
                return
            }
            
            let uSource: USource = zelf.f(t)
            
            cd.dispose()
            
            cd.add(uSource.addHandler { (u: U) in
                handler(u)
            })
        }
        return disposer
    }
    
    private let source: TSource
    private let f: (T) -> USource
}

public extension EventSourceProtocol {
    func flatMapLatest<USource: EventSourceProtocol>(_ f: @escaping (Event) -> USource) -> EventSource<USource.Event> {
        return EventSourceFlatMapLatest(self, f).asEventSource()
    }
}
