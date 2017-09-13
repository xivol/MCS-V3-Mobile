import Foundation

public protocol XOdelegate : MultiplayerGameDelegate, GameDelegate, MultiplayerTurnbasedGameDelegate {
    
}

public class gameLogic : MultiplayerGame {

    public var name: String = "tic-tac-toe"
    public func play() {
        delegate?.gameDidStart(self)
        startPlaying()
        makeTurns()
        end()
    }

    public var delegate : XOdelegate?
    
    private var was_finished: Bool = false
    public var players: [player] = [playerXO(kindOfMark.O), playerXO(kindOfMark.X)]
    private var r = randomGeneratorXO()
    private var brd = board()
    private var step: Int = 0
    public init () { }
    
    public init(_ deleg: XOdelegate?) {
        delegate = deleg
    }
    
    private func makeStep() -> (p1: Int, p2: Int) {
        return players[step % 2].makeStep(brd, r)
    }
    
    // Инициализировать новую игру
    private func startPlaying() {
        brd = board()
        step = 0
        was_finished = false
    }
    
    // Начать игру
    private func makeTurns()  {
        while  brd.freeSquare.count > 0 {
            delegate?.playerDidStartTurn(players[step % 2])
            let st = makeStep()
            delegate?.player(players[step % 2], didTakeAction: playerAction.move(st.p1 + 1, st.p2 + 1, players[step % 2].kind))
            if (players[step % 2].checkResult(brd, st)) {
                delegate?.player(players[step % 2], didTakeAction: playerAction.win)
                brd.printTable()
                was_finished = true
                return
                
            }
            brd.printTable()
            delegate?.playerDidEndTurn(players[step % 2])
            step += 1
        }
    }
    
    public func end() {
        if (!was_finished) {
            delegate?.player(nil, didTakeAction: playerAction.draw)
        }
        delegate?.gameDidEnd(self)
    }
}
