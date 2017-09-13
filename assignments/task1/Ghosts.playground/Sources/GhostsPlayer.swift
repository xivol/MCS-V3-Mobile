

public protocol Player: class {
    
    associatedtype GameItem
    
    var name: String { get }
    var items: [GameItem] { get }
    
    func add(_ item: GameItem)
    func remove(_ item: GameItem)
    
}

public extension Player {
    
    func add(_ item: GameItem) {}
    func remove(_ item: GameItem) {}
    
}

public final class GhostsPlayer: Player {
    
    public let name: String
    private(set) public var items: [Ghost]
    
    private var capturedGhosts: [Ghost]
    
    public var blueCapturedGhostsCount: Int {
        return capturedGhosts.count(where: { $0.marker == .blue })
    }
    
    public var redCapturedGhostsCount: Int {
        return capturedGhosts.count(where: { $0.marker == .red })
    }
    
    public var didEscape: Bool
    
    public init(name: String, items: [Ghost]) {
        assert(items.count == 8, "Each player must have 8 ghosts due to the game rules")
        
        self.name = name
        self.items = items
        self.capturedGhosts = []
        self.didEscape = false
        
        self.items.forEach { $0.owner = self }
    }
    
    public func remove(_ item: Ghost) {
        guard let itemIndex = items.index(where: { $0 === item }) else { return }
        items.remove(at: itemIndex)
    }
    
    public func capture(_ ghost: Ghost) {
        capturedGhosts.append(ghost)
    }
    
}
