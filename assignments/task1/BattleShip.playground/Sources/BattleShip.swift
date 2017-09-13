import Foundation

public protocol BattleShipDelegate: TwoPlayerFireBasedGameDelegate, RandomStepGameDelegate {}

public class BattleShip: RandomStepGame, TwoPlayerGame, FireBasedGame {
  public var randomStep = RandomStep(initValue: 42, generator: LinearCongruentialGenerator())
  var numberOfFires = 0
  var firstPlayer, secondPlayer: Player
  public let name = "BattleShip"
  public var delegate: BattleShipDelegate?
  public var player1: Player {
    get {
      return firstPlayer
    }
  }
  public var player2: Player {
    get{
      return secondPlayer
    }
  }
  public init() {
    self.firstPlayer = BattleShipPlayer(name: "none")
    self.secondPlayer = BattleShipPlayer(name: "none")
  }
  public func join (player: Player) {
    if firstPlayer.name == "none" {
      firstPlayer = player
    } else {
      secondPlayer = player
    }
    delegate?.player(player, didJoinTheGame: self)
  }
  
  public var fires: Int {
    get { return numberOfFires }
  }
  
  public var hasEnded: Bool {
    get {
      return !(player1.alive && player2.alive)
    }
  }
  
  public func start() {
    delegate?.gameDidStart(self)
  }
  
  public func end() {
    var winner = player1
    if player2.alive {
      winner = player2
    }
    delegate?.player(winner, didTakeAction: .win)
    delegate?.gameDidEnd(self)
  }
  
  public func playerMakeFire( _ assaulter: inout Player, answerer: inout Player) {
    delegate?.playerDidStartFire(assaulter)
    var nextPos = randomStep.roll()
    while assaulter.didThisStepBefore(nextPos) {
      nextPos = randomStep.roll()
    }
    delegate?.game(self, didRandomStep: nextPos)
    delegate?.player(assaulter, didTakeAction: PlayerAction.fire((nextPos.0, nextPos.1)))
    let answer = answerer.doEnemyStep(nextPos.0, yPos: nextPos.1)
    delegate?.player(answerer, didTakeAction: PlayerAction.answer(result: answer))
    assaulter.saveEnemyAnswer(nextPos.0, yPos: nextPos.1, answer: answer)
    delegate?.playerDidEndFire(assaulter)
  }
  
  public func makeFire() {
    numberOfFires += 1
    delegate?.gameDidStartFire(self)
    playerMakeFire(&firstPlayer, answerer: &secondPlayer)
    playerMakeFire(&secondPlayer, answerer: &firstPlayer)
    delegate?.gameDidEndFire(self)
  }
  
}
