import Foundation

// Game

public protocol MultiplayerGame {
    var players: [Player] { get }
    func join(player: Player)
}

// Delegates

public protocol MultiplayerGameDelegate: GameDelegate {
    func player(_ player: Player, didJoinTheGame game: MultiplayerGame)
    func player(_ player: Player, didTakeAction action: PlayerAction)
}

// Default Implementation

extension MultiplayerGameDelegate {
    public func player(_ player: Player, didJoinTheGame game: MultiplayerGame) {
        print("\(player.name) has joined the game")
    }
    
    public func player(_ player: Player, didTakeAction action: PlayerAction) {
        switch action {
        case .win:
            print("\(player.name) wins!")
        case let .move(square):
            print("\(player.name) moves to \(square)")
        }
    }
}
