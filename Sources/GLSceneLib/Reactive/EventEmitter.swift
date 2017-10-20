public class EventEmitter<Event> : EventSourceProtocol {
    public init() {}
    
    public func addHandler(_ handler: @escaping (Event) -> ()) -> Disposer {
        let box = HandlerBox(handler)
        handlers.append(box)
        return Disposer { [weak self] in
            self?.handlers.remove { $0 === box }
        }
    }
    
    public func emit(_ event: Event) {
        let handlers = self.handlers
        handlers.forEach { handler in
            handler.value(event)
        }
    }
    
    private typealias HandlerBox = Box<(Event) -> ()>
    
    private var handlers: [HandlerBox] = []
}
