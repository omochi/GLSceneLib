public class EventSourceFlatMapLatest<X: EventSourceProtocol, U> : EventSourceProtocol {
    public init(_ source: X, _ f: @escaping (X.Event) -> EventSource<U>) {
        self.source = source
        self.f = f
    }
    
    public func addHandler(_ handler: @escaping (U) -> ()) -> Disposer {
        let cd = CompositeDisposer()
        let disposer = source.addHandler { [weak self] (t: X.Event) in
            guard let zelf = self else {
                return
            }
            
            let uEvent = zelf.f(t)
            
            cd.dispose()
            
            cd.add(uEvent.addHandler { (u: U) in
                handler(u)
            })
        }
        return disposer
    }
    
    private let source: X
    private let f: (X.Event) -> EventSource<U>
}

public extension EventSourceProtocol {
    func flatMapLatest<U>(_ f: @escaping (Event) -> EventSource<U>) -> EventSource<U> {
        return EventSourceFlatMapLatest(self, f).asEventSource()
    }
}
