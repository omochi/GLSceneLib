public protocol DisposerProtocol {
    func dispose()
}

extension DisposerProtocol {
    public func asDisposer() -> Disposer {
        return Disposer(self)
    }
}

public class Disposer : DisposerProtocol {
    public init() {}

    public init<X: DisposerProtocol>(_ base: X) {
        self.proc = { base.dispose() }
    }
    
    public init(_ proc: @escaping () -> Void) {
        self.proc = proc
    }
    
    public func dispose() {
        if let proc = proc {
            self.proc = nil
            proc()
        }
    }
    
    public func disposed(by bag: DisposeBag) {
        bag.add(self)
    }
    
    private var proc: (() -> Void)?
}
