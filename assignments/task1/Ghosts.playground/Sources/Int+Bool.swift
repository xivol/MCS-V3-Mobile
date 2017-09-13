

public extension Int {
    
    public init(value: Bool) {
        let integerValue = value ? 1 : 0
        self.init(integerValue)
    }
    
    public init(_ value: Bool) {
        self.init(value: value)
    }
    
}
