import Foundation

// игра в сущности
public protocol Game {
    var name: String { get }
    func play()
}

// многопользовательская игра
public protocol MultiplayerGame: Game {
    var players: [player] { get }
}

//---------------------------------------
// делегат о начале и конце игры
public protocol GameDelegate {
    func gameDidStart(_ game: Game)
    func gameDidEnd(_ game: Game)
}


//  реализация по-умолчанию
extension GameDelegate {
    public func gameDidStart(_ game: Game) {
        print("Started a new game of \(game.name)")
    }
    
    public func gameDidEnd(_ game: Game) {
        print("Ended a game of \(game.name)")
    }
}
//---------------------------------------





//---------------------------------------
// отчет о событии, произошедшем на доске от игрока
public protocol MultiplayerGameDelegate: GameDelegate {
    func player(_ player: player?, didTakeAction action: playerAction)
}

// результат хода игрока
extension MultiplayerGameDelegate {
    
    public func player(_ player: player?, didTakeAction action: playerAction) {
        switch action {
        case .win:
            print("\(player!.name) wins!")
        case let .move(x, y, kindOM):
            print("\(player!.name) move to (\(x), \(y)) and mark \(getType(kindOM))")
        case .draw:
            print("nobody win, draw, try again")
        }
    }
}

//---------------------------------------



//---------------------------------------
// отчет о начале хода игрока и его завершении
public protocol MultiplayerTurnbasedGameDelegate: MultiplayerGameDelegate {
    func playerDidStartTurn(_ player: player)
    func playerDidEndTurn(_ player: player)
}

extension MultiplayerTurnbasedGameDelegate {
    public func playerDidStartTurn(_ player: player) {
        print("\(player.name) thinking...")
    }
    public func playerDidEndTurn(_ player: player) {
    print("\(player.name) ended\n")
    }
}
//---------------------------------------
