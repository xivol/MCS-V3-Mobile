import Foundation



public class BattleShipPlayer: Player {
  
  var field: BattleField
  var ships: [Ship]
  public let name: String
  
  
  public func saveEnemyAnswer(_ xPos: Int, yPos: Int, answer: FireResult) {
    switch answer {
    case .misses:
      field.markCellAtAs(xPos, yPos: yPos, state: .missed)
    default:
      field.markCellAtAs(xPos, yPos: yPos, state: .enemyCell)
    
    }
  }

  public func doEnemyStep(_ xPos: Int, yPos: Int) -> FireResult {
    if let shipIndex = ships.index(where: { $0.isHit(xPos, yPos: yPos)})  {
      if ships[shipIndex].alive {
        return .injured
      }else {
        ships.remove(at: shipIndex)
        return .killed
      }
    }
    return .misses
  }
  
  public func didThisStepBefore(_ position: (xPos: Int, yPos: Int)) -> Bool {
    return !field.isNonTouchedPosition(position.xPos, yPos: position.yPos)
  }
  
  public var alive: Bool {
    get {
      return ships.count != 0
    }
  }
  

  
  public init(name: String, _ ships: [Ship] = Array()) {
    field = BattleField()
    self.ships = ships
    self.name = name
  }
}

public class BattleShipTracker: BattleShipDelegate {

  public func gameDidStartFire(_ game: FireBasedGame) {
    print("===-===-===")
  }
  
  public func playerDidStartFire(_ player: Player) {
    print("\(player.name) is choosing cell")
  }
  
  public init() {}
}
