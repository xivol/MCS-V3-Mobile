import Foundation

public class IsolaPlayer: Player {
  public let name: String
  public var pos:  Point
  
  public init(name: String, pos: Point) {
    self.name = name
    self.pos  = pos
  }
}

public class IsolaTracker: IsolaDelegate {
  public init(){}
  
  public func gameDidStartTurn(_ game: TurnbasedGame) {
    print("===-===-===")
  }
  
  public func playerDidStartTurn(_ player: Player) {
    print("\(player.name) is thinking")
  }
}
