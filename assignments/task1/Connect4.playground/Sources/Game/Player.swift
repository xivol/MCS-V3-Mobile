import Foundation

public protocol Player {
    var name: String { get }
}

public enum PlayerAction {
    case win
    case move(square: Int)
}
