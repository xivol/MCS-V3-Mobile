import Foundation

// Game

public protocol RandomStepGame: Game {
  var randomStep: RandomStep { get }
}

// Delegates

public protocol RandomStepGameDelegate: GameDelegate {
  func game(_ game: RandomStepGame, didRandomStep randomStep: (Int, Int))
}

// Default Implementation

extension RandomStepGameDelegate {
  public func game(_ game: RandomStepGame, didRandomStep randomStep: (Int, Int)) {
    print("Сhoosen cell is a \(randomStep.0) \(randomStep.1)")
  }
}
