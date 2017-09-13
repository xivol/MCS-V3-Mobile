import Foundation

// MARK: TurnbasedGame

public protocol TurnbasedGame: Game {
  var turns: Int { get }
  var hasEnded: Bool { get }
  func start()
  func makeTurn()
  func end()
}

// Delegate

public protocol TurnbasedGameDelegate: GameDelegate {
  func gameDidStartTurn(_ game: TurnbasedGame)
  func gameDidEndTurn(_ game: TurnbasedGame)
  func playerDidStartTurn(_ player: Player)
  func playerDidEndTurn(_ player: Player)
}

// Default Implementation

extension TurnbasedGame {
  public func play() {
    start()
    while !self.hasEnded {
      makeTurn()
    }
    end()
  }
}

extension TurnbasedGameDelegate {
  public func gameDidStartTurn(_ game: TurnbasedGame) {}
  public func gameDidEndTurn(_ game: TurnbasedGame) {}
  
  public func gameDidEnd(_ game: Game) {
    print("The game lasted for \((game as! TurnbasedGame).turns) turns")
  }
  
  public func playerDidStartTurn(_ player: Player) {}
  public func playerDidEndTurn(_ player: Player) {}
}
