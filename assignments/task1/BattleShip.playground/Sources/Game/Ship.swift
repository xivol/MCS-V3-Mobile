import Foundation

//type of Ship
public typealias ShipLocation = [(xPos: Int, yPos: Int)]

public protocol Ship {
  var alive: Bool { get }
  func isHit(_ xPos: Int, yPos: Int) -> Bool
}

public class CombatShip: Ship {
  var location: ShipLocation
  var holeCount: Int
  public var alive: Bool {
    get {
      return holeCount < location.count
    }
  }
  
  public func isHit(_ xPos: Int, yPos: Int) -> Bool {
    if location.index(where: { $0.xPos == xPos && $0.yPos == yPos }) != nil{
      holeCount += 1
      return true
    }
    return false
  }
  
  public init(_ location: ShipLocation) {
    self.location = location
    holeCount = 0
  }
}
