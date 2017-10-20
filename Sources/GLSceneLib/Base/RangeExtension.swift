public extension Range where Bound : FloatingPoint {
    func blend(_ rate: Bound) -> Bound {
        return lowerBound * (Bound(1) - rate) + upperBound * rate
    }
}
