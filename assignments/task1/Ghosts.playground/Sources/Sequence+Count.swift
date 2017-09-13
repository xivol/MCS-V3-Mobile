

extension Sequence {
    
    public func count(where predicate: (Iterator.Element) -> Bool) -> Int {
        return reduce(0) { (accumulator: Int, element: Iterator.Element) in
            accumulator + Int(predicate(element))
        }
    }
    
}
