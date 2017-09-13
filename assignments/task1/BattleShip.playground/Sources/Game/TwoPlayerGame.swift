import Foundation

// Game

public protocol TwoPlayerGame: Game {
  var player1: Player { get }
  var player2: Player { get }
  func join(player: Player)
}

// Delegates

public protocol TwoPlayerGameDelegate: GameDelegate {
  func player(_ player: Player, didJoinTheGame game: TwoPlayerGame)
  func player(_ player: Player, didTakeAction action: PlayerAction)
}

public protocol TwoPlayerFireBasedGameDelegate: FireBasedGameDelegate, TwoPlayerGameDelegate {
  func playerDidStartFire(_ player: Player)
  func playerDidEndFire(_ player: Player)
}

// Default Implementation

extension TwoPlayerGameDelegate {
  public func player(_ player: Player, didJoinTheGame game: TwoPlayerGame) {
    print("\(player.name) has joined the game")
  }
  
  public func player(_ player: Player, didTakeAction action: PlayerAction) {
    switch action {
    case .win:
      print("\(player.name) wins!")
    case let .fire(position):
      print("\(player.name) fires to \(position.0) \(position.1)")
    case let .answer(fireResult):
      print("\(player.name) says \(fireResult)")
    }
  }
}

extension TwoPlayerFireBasedGameDelegate {
  public func playerDidStartFire(_ player: Player) {}
  public func playerDidEndFire(_ player: Player) {}
}
