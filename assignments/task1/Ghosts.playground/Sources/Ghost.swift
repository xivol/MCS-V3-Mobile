

public final class Ghost {
    
    public enum Marker {
        case red, blue
    }
    
    public let marker: Marker
    public weak var owner: GhostsPlayer?
    
    public init (marker: Marker) {
        self.marker = marker
    }
    
}

extension Ghost: CustomStringConvertible {
    
    public var description: String {
        switch marker {
        case .red: return "🔴"
        case .blue: return "🔵"
        }
    }
    
}
