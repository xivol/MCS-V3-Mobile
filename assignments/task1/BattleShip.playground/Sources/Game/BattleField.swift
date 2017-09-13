import Foundation

public enum CellState {
  case nonTouched
  case missed
  case enemyCell
}

public protocol Field{
  func getCellAt(_ xPos: Int, yPos: Int) -> CellState
  func markCellAtAs(_ xPos: Int, yPos: Int, state: CellState)
  func isNonTouchedPosition(_ xPos: Int, yPos: Int) -> Bool
}

public class BattleField: Field {
  
  private var field: [[CellState]]
  
  public func getCellAt(_ xPos: Int, yPos: Int) -> CellState {
    return field[xPos][yPos]
  }
  
  public func markCellAtAs(_ xPos: Int, yPos: Int, state: CellState) {
    field[xPos][yPos] = state
  }
  
  public func isNonTouchedPosition(_ xPos: Int, yPos: Int) -> Bool {
    return field[xPos][yPos] == CellState.nonTouched
  }
  
  public init(_ fieldSize: Int = 10) {
    field = Array(repeating: (Array(repeating: CellState.nonTouched, count: fieldSize)), count: fieldSize)
  }
}



