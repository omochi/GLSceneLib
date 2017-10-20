public class DisposeBag {
    public init() {}
    
    deinit {
        disposers.dispose()
    }
    
    public func add(_ disposer: Disposer) {
        disposers.add(disposer)
    }
    
    private let disposers = CompositeDisposer()
}
