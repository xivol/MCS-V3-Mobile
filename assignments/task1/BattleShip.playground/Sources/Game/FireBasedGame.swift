import Foundation

// MARK: FireBasedGame

public protocol FireBasedGame: Game {
  var fires: Int { get }
  var hasEnded: Bool { get }
  func start()
  func makeFire()
  func end()
}

// Delegate

public protocol FireBasedGameDelegate: GameDelegate {
  func gameDidStartFire(_ game: FireBasedGame)
  func gameDidEndFire(_ game: FireBasedGame)
}

// Default Implementation

extension FireBasedGame {
  public func play() {
    start()
    while !self.hasEnded {
      makeFire()
    }
    end()
  }
}

extension FireBasedGameDelegate {
  public func gameDidStartFire(_ game: FireBasedGame) {}
  public func gameDidEndFire(_ game: FireBasedGame) {}
  
  public func gameDidEnd(_ game: Game) {
    print("The game lasted for \((game as! FireBasedGame).fires) fires")
  }
}
