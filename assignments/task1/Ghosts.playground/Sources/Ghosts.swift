import Darwin

public protocol TurnbasedGame: class {
    
    var turns: Int { get }
    var hasEnded: Bool { get }
    
    func play()
    func start()
    func makeTurn()
    func end()
    
}

public extension TurnbasedGame {
    
    func play() {
        start()
        while !self.hasEnded {
            makeTurn()
        }
        end()
    }
    
    func start() {}
    func end() {}
    
}

public protocol GhostsDelegate {
    
    func didStart(_ game: Ghosts)
    func didBeginTurn(_ player: GhostsPlayer, in game: Ghosts)
    func didEndTurn(_ player: GhostsPlayer, with result: GhostsMovementResult, in game: Ghosts)
    func didFinish(_ game: Ghosts, with result: Ghosts.Result)
    
}

public final class Ghosts: TurnbasedGame {
    
    public enum Result {
        case escape(player: GhostsPlayer)
        case captureFourBlueGhosts(player: GhostsPlayer)
        case captureFourRedGhosts(player: GhostsPlayer, winner: GhostsPlayer)
    }
    
    public let firstPlayer: GhostsPlayer
    public let secondPlayer: GhostsPlayer
    public var gameBoard: GhostsGameBoard
    
    private(set) public var turns: Int
    
    private var gameResult: Result {
        if firstPlayer.didEscape {
            return .escape(player: firstPlayer)
        }
        
        if secondPlayer.didEscape {
            return .escape(player: secondPlayer)
        }
        
        if firstPlayer.blueCapturedGhostsCount == 4 {
            return .captureFourBlueGhosts(player: firstPlayer)
        }
        
        if secondPlayer.blueCapturedGhostsCount == 4 {
            return .captureFourBlueGhosts(player: secondPlayer)
        }
        
        if firstPlayer.redCapturedGhostsCount == 4 {
            return .captureFourRedGhosts(player: firstPlayer, winner: secondPlayer)
        }
        
        if secondPlayer.redCapturedGhostsCount == 4 {
            return .captureFourRedGhosts(player: secondPlayer, winner: firstPlayer)
        }
        
        fatalError("Unknown win strategy")
    }
    
    public var delegate: GhostsDelegate?
    
    public init(firstPlayer: GhostsPlayer, secondPlayer: GhostsPlayer, gameBoard: GhostsGameBoard) {
        self.firstPlayer = firstPlayer
        self.secondPlayer = secondPlayer
        self.gameBoard = gameBoard
        self.turns = 0
    }
    
    // MARK: - TurnbasedGame
    
    public var hasEnded: Bool {
        let escapeWinStrategy = firstPlayer.didEscape || secondPlayer.didEscape
        let firstCaptureWinStrategy = firstPlayer.blueCapturedGhostsCount == 4 || secondPlayer.blueCapturedGhostsCount == 4
        let secondCaptureWinStrategy = firstPlayer.redCapturedGhostsCount == 4 || secondPlayer.redCapturedGhostsCount == 4
        
        return escapeWinStrategy || firstCaptureWinStrategy || secondCaptureWinStrategy
    }
    
    public func start() {
        delegate?.didStart(self)
    }
    
    public func makeTurn() {
        turns += 1
        
        let player = self.player(forTurn: turns)
        
        delegate?.didBeginTurn(player, in: self)
        
        var item: Ghost
        var movementDirections: [Direction]
        
        repeat {
            let availabelPlayerItems = player.items.count
            let randomItemIndex = arc4random_uniform(UInt32(availabelPlayerItems))
            item = player.items[Int(randomItemIndex)]
            movementDirections = gameBoard.movementDirections(for: item)
        } while movementDirections.isEmpty
        
        let randomDirectionIndex = arc4random_uniform(UInt32(movementDirections.count))
        let direction = movementDirections[Int(randomDirectionIndex)]
        
        let movementResult = gameBoard.move(item, direction)
        switch movementResult {
        case .move: break
        case let .moveAndCapture(_, _, capturedGhost):
            player.capture(capturedGhost)
            capturedGhost.owner?.remove(capturedGhost)
        case .escape: player.didEscape = true
        }
        
        delegate?.didEndTurn(player, with: movementResult, in: self)
    }
    
    public func end() {
        delegate?.didFinish(self, with: gameResult)
    }
    
    private func player(forTurn turn: Int) -> GhostsPlayer {
        if turn % 2 == 0 {
            return firstPlayer
        } else {
            return secondPlayer
        }
    }
    
}
