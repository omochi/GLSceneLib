public class CompositeDisposer : DisposerProtocol {
    public init() {}

    public func add(_ disposer: Disposer) {
        self.disposers.append(disposer)
    }
    
    public func add<X: Sequence>(contentsOf sequence: X)
        where X.Element == Disposer
    {
        self.disposers.append(contentsOf: sequence)
    }
    
    public func dispose() {
        let disposers = self.disposers
        self.disposers = []
        disposers.forEach { disposer in
            disposer.dispose()
        }
    }
    
    private var disposers: [Disposer] = []
}

