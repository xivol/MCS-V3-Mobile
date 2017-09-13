

extension Direction: CustomStringConvertible {
    
    public var description: String {
        switch self {
        case .forward: return "forward"
        case .left: return "left"
        case .backward: return "backward"
        case .right: return "right"
        }
    }
    
}

extension Ghosts.Result: CustomStringConvertible {
    
    public var description: String {
        switch self {
        case let .escape(player):
            return "\(player.name) is the winner since he escaped using his 🔵 ghost"
        case let .captureFourBlueGhosts(player):
            return "\(player.name) is the winner since he was the first who captured 4 blue ghosts"
        case let .captureFourRedGhosts(player, winner):
            return "\(winner.name) is the winner since \(player.name) captured 4 red ghosts"
        }
    }
    
}

public struct GhostsSessionLogger: GhostsDelegate {
    
    private var separator: String {
        return "-------------"
    }
    
    public init() {}
    
    public func didStart(_ game: Ghosts) {
        print("Game is started for two players: \(game.firstPlayer.name) and \(game.secondPlayer.name)")
        print(game.gameBoard)
    }
    
    public func didBeginTurn(_ player: GhostsPlayer, in game: Ghosts) {
        print(separator)
        print("\(player.name) is starting turn #\(game.turns)")
    }
    
    public func didEndTurn(_ player: GhostsPlayer, with result: GhostsMovementResult, in game: Ghosts) {
        var logString = "\(player.name) is ended turn by "
        
        switch result {
        case let .escape(direction):
            logString += "escaping using \(direction) castle"
        case let .move(ghost, direction):
            logString += "moving \(direction) \(ghost)"
        case let .moveAndCapture(ghost, direction, capturedGhost):
            logString += "moving \(direction) \(ghost) and capturing \(capturedGhost.owner!.name)'s \(capturedGhost)"
        }
        
        print(logString + "\n")
        print(game.gameBoard)
    }
    
    public func didFinish(_ game: Ghosts, with result: Ghosts.Result) {
        print(separator)
        print("Game is ended with the result: \(result)")
    }

}
