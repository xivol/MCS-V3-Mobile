import Foundation

public protocol Player {
  var name: String { get }
  var pos: Point { get set }
}

public enum PlayerAction {
  case win
  case move(pos: Point)
  case remove(pos: Point)
}
