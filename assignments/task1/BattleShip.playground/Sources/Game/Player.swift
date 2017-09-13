import Foundation

public enum FireResult {
  case misses
  case injured
  case killed
}

public protocol Player {
  var name: String { get }
  var alive: Bool { get }
  func doEnemyStep(_ xPos: Int, yPos: Int) -> FireResult
  func saveEnemyAnswer(_ xPos: Int, yPos: Int, answer: FireResult)
  func didThisStepBefore(_ position: (xPos: Int, yPos: Int)) -> Bool
}

public enum PlayerAction {
  case win
  case fire((x: Int, y: Int))
  case answer(result: FireResult)
}
