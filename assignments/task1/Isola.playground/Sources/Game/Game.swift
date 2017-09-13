import Foundation

// Game

public protocol Game {
  var name: String { get }
  func play()
}

// Delegates

public protocol GameDelegate {
  func gameDidStart(_ game: Game)
  func gameDidEnd(_ game: Game)
  func player(_ player: Player, didTakeAction action: PlayerAction)
}

// Default Implementation

extension GameDelegate {
  public func gameDidStart(_ game: Game) {
    print("Started a new game of \(game.name)")
  }
  
  public func gameDidEnd(_ game: Game) { }
  
  public func player(_ player: Player, didTakeAction action: PlayerAction) {
    switch action {
    case .win:
      print("\(player.name) wins!🎉")
    case let .move(pos):
      print("\(player.name) 🚶🏻 to (\(pos.x), \(pos.y))")
    case let .remove(pos):
      print("\(player.name) 💥 square (\(pos.x), \(pos.y))")
    }
  }
}
