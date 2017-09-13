import Foundation

public protocol IsolaDelegate: TurnbasedGameDelegate {}

public class Isola: Game, TurnbasedGame {
  public let name = "Isola"
  
  var board: Array<Array<Int>>
  var numberOfTurns = 0
  
  public var fstPlayer: IsolaPlayer
  public var sndPlayer: IsolaPlayer
  
  public var delegate: IsolaDelegate?
  
  public init(fieldSize size: Int) {
    board = Array<Array<Int>>()
    for _ in 1...size {
      //            0    - empty
      //            -1   - removed
      //            1, 2 - player
      board.append(Array(repeating: 0, count: size))
    }
    
    let fstPlayerPos = Point(x: 0, y: board.count / 2)
    let sndPlayerPos = Point(x: board.count - 1, y: board.count / 2)
    
    fstPlayer = IsolaPlayer(name: "Player 1", pos: fstPlayerPos)
    sndPlayer = IsolaPlayer(name: "Player 2", pos: sndPlayerPos)
    
    board[fstPlayerPos.x][fstPlayerPos.y] = 1
    board[sndPlayerPos.x][sndPlayerPos.y] = 2
  }
  
  public convenience init() {
    self.init(fieldSize: 7)
  }
  
  func playerHasTurn(_ player: IsolaPlayer) -> Bool {
    let x = player.pos.x
    let y = player.pos.y
    
    var result = false
    
    if x > 0 {
      if y > 0 {
        result = result || (board[x-1][y-1] == 0)
      }
      result = result || (board[x-1][y] == 0)
      if y < (board.count - 1) {
        result = result || (board[x-1][y+1] == 0)
      }
    }
    if x < (board.count - 1) {
      if y > 0 {
        result = result || (board[x+1][y-1] == 0)
      }
      result = result || (board[x+1][y] == 0)
      if y < (board.count - 1) {
        result = result || (board[x+1][y+1] == 0)
      }
    }
    if y > 0 {
      result = result || (board[x][y-1] == 0)
    }
    if y < (board.count - 1) {
      result = result || (board[x][y+1] == 0)
    }
    
    return result
  }
  
  func playerPossibleMoves(_ player: IsolaPlayer) -> Array<Point> {
    let x = player.pos.x
    let y = player.pos.y
    
    var result = Array<Point>()
    
    if x > 0 {
      if y > 0 && board[x-1][y-1] == 0 {
        result.append(Point(x: x-1, y: y-1))
      }
      if board[x-1][y] == 0 {
        result.append(Point(x: x-1, y: y))
      }
      if y < (board.count - 1) && board[x-1][y+1] == 0 {
        result.append(Point(x: x-1, y: y+1))
      }
    }
    if x < (board.count - 1) {
      if y > 0 && board[x+1][y-1] == 0 {
        result.append(Point(x: x+1, y: y-1))
      }
      if board[x+1][y] == 0 {
        result.append(Point(x: x+1, y: y))
      }
      if y < (board.count - 1) && board[x+1][y+1] == 0 {
        result.append(Point(x: x+1, y: y+1))
      }
    }
    if y > 0 && board[x][y-1] == 0 {
      result.append(Point(x: x, y: y-1))
    }
    if y < (board.count - 1) && board[x][y+1] == 0 {
      result.append(Point(x: x, y: y+1))
    }
    
    return result
  }
  
  public var turns: Int {
    return numberOfTurns
  }
  
  public var hasEnded: Bool {
    return !playerHasTurn(fstPlayer) || !playerHasTurn(sndPlayer)
  }
  
  public func start() {
    delegate?.gameDidStart(self)
  }
  
  public func end() {
    delegate?.player(playerHasTurn(fstPlayer) ? fstPlayer : sndPlayer, didTakeAction: .win)
    delegate?.gameDidEnd(self)
  }
  
  public func playerMakeTurn( _ player: inout IsolaPlayer) {
    delegate?.playerDidStartTurn(player)
    
    let playerMarker = player.name == "Player 1" ? 1 : 2
    
    //        print("playerPossibleMoves (\(player.pos.x), \(player.pos.y))")
    //        print(board)
    //        print(playerPossibleMoves(player: player))
    let possMoves = playerPossibleMoves(player)
    let newPos: Point = possMoves[Int(arc4random()) % possMoves.count]
    
    //        print("continue")
    
    board[newPos.x][newPos.y] = playerMarker
    board[player.pos.x][player.pos.y] = 0
    player.pos = newPos
    
    delegate?.player(player, didTakeAction: .move(pos: player.pos))
    
    //        print("removing pos")
    
    var removePos: Point
    repeat {
      removePos = Point(x: Int(arc4random()) % board.count, y: Int(arc4random()) % board.count)
    } while !(board[removePos.x][removePos.y] == 0)
    
    board[removePos.x][removePos.y] = -1
    
    delegate?.player(player, didTakeAction: .remove(pos: removePos))
    
    delegate?.playerDidEndTurn(player)
  }
  
  public func makeTurn() {
    numberOfTurns += 1
    delegate?.gameDidStartTurn(self)
    
    //        TODO: почему не работает, если в заголовке Player
    playerMakeTurn(&fstPlayer)
    if !self.hasEnded {
      playerMakeTurn(&sndPlayer)
    }
    
    printBoard()
    delegate?.gameDidEndTurn(self)
  }
  
  func getEmoji(_ elem: Int) -> String {
    switch elem {
    case 0:
      return "◻️"
    case -1:
      return "◼️"
    case 1:
      return "🌝"
    case 2:
      return "🌚"
    default:
      return ""
    }
  }
  
  func printBoard() {
    for row in board {
      print(row.map({"\(getEmoji($0))"}).joined(separator: ""))
    }
  }
}
