

public enum Direction {

    case forward
    case left
    case backward
    case right

}

public enum GhostsMovementResult {

    case move(ghost: Ghost, direction: Direction)
    case moveAndCapture(ghost: Ghost, direction: Direction, capturedGhost: Ghost)
    case escape(direction: Direction)

}

public protocol GameBoard {

    typealias BoardSize = (rows: Int, columns: Int)
    var size: BoardSize { get }
}


public protocol GhostsGameBoard: GameBoard {
 
    func movementDirections(for ghost: Ghost) -> [Direction]
    
    mutating func move(_ ghost: Ghost, _ direction: Direction) -> GhostsMovementResult
    mutating func remove(_ ghost: Ghost)

}

public struct _GhostsGameBoard<P: Player>: GhostsGameBoard where P.GameItem == Ghost {
    
    fileprivate var board: ContiguousArray<Ghost?>
    
    public let size: BoardSize
    
    // Hold reference to players to perform logic
    // connected with movement rules
    fileprivate let firstPlayer: P
    fileprivate let secondPlayer: P
    
    public init(size: BoardSize, firstPlayer: P, secondPlayer: P) {
        self.board = ContiguousArray(repeating: nil, count: size.rows * size.columns)
        self.size = size
        self.firstPlayer = firstPlayer
        self.secondPlayer = secondPlayer
        
        placeItems(of: firstPlayer, startingFromRowAtIndex: 0)
        placeItems(of: secondPlayer, startingFromRowAtIndex: size.columns - 2)
    }
    
    // MARK: - GhostsGameBoard
    
    public func movementDirections(for item: Ghost) -> [Direction] {
        guard let itemIndex = board.index(where: { $0 === item }) else { return [] }
        
        var directions: [Direction] = []
        
        // Directions for escaping
        if itemIndex == 0 && item.owner === secondPlayer && item.marker == .blue {
            directions.append(.left)
        }
        
        if itemIndex == size.columns - 1 && item.owner === secondPlayer && item.marker == .blue {
            directions.append(.right)
        }
        
        if itemIndex == size.rows * (size.columns - 1) && item.owner === firstPlayer && item.marker == .blue {
            directions.append(.left)
        }
        
        if itemIndex == size.rows * size.columns - 1 && item.owner === firstPlayer && item.marker == .blue {
            directions.append(.right)
        }
        
        // Regular directions
        if  itemIndex - 1 > 0 &&
            (board[itemIndex - 1] == nil || board[itemIndex - 1]!.owner !== item.owner)
        {
            let direction: Direction = item.owner === firstPlayer ? .right : .left
            directions.append(direction)
        }
        
        if itemIndex + 1 < size.rows &&
           (board[itemIndex + 1] == nil || board[itemIndex + 1]!.owner !== item.owner)
        {
            let direction: Direction = item.owner === firstPlayer ? .left : .right
            directions.append(direction)
        }
        
        if itemIndex + size.columns < size.columns * size.rows &&
           (board[itemIndex + size.columns] == nil || board[itemIndex + size.columns]!.owner !== item.owner)
        {
            let direction: Direction = item.owner === firstPlayer ? .forward : .backward
            directions.append(direction)
        }
        
        if itemIndex - size.columns >= 0 &&
           (board[itemIndex - size.columns] == nil || board[itemIndex - size.columns]!.owner !== item.owner)
        {
            let direction: Direction = item.owner === firstPlayer ? .backward : .forward
            directions.append(direction)
        }

        return directions
    }
    
    public mutating func move(_ ghost: Ghost, _ direction: Direction) -> GhostsMovementResult {
        guard let itemIndex = board.index(where: { $0 === ghost }) else { fatalError() }
        
        board[itemIndex] = nil
        
        // Handle escaping
        if (ghost.owner === firstPlayer) {
            if ((itemIndex == size.rows * (size.columns - 1) && direction == .right) ||
                (itemIndex == size.rows * size.columns - 1 && direction == .left)) {
                return .escape(direction: direction)
            }
        }
        
        if (ghost.owner === secondPlayer) {
            if ((itemIndex == 0 && direction == .left) ||
                (itemIndex == size.columns - 1  && direction == .right)) {
                return .escape(direction: direction)
            }
        }
        
        // Handle regular movement
        let newItemIndex: Int
        switch direction {
        case .forward:
            let i = ghost.owner === firstPlayer ? 1 : -1
            newItemIndex = itemIndex + size.columns * i
        case .left:
            let i = ghost.owner === firstPlayer ? 1 : -1
            newItemIndex = itemIndex + i
        case .backward:
            let i = ghost.owner === firstPlayer ? -1 : 1
            newItemIndex = itemIndex + size.columns * i
        case .right:
            let i = ghost.owner === firstPlayer ? -1 : 1
            newItemIndex = itemIndex + i
        }
        
        defer {
            board[newItemIndex] = ghost
        }
        
        if let itemAtNewIndex = board[newItemIndex], itemAtNewIndex.owner !== ghost {
            return .moveAndCapture(ghost: ghost, direction: direction, capturedGhost: itemAtNewIndex)
        } else {
            return .move(ghost: ghost, direction: direction)
        }
    }
    
    public mutating func remove(_ ghost: Ghost) {
        guard let itemIndex = board.index(where: { $0 === ghost }) else { return }
        board[itemIndex] = nil
    }
    
    // MARK: - Private
    
    private mutating func placeItems(of player: P, startingFromRowAtIndex row: Int) {
        let items = player.items
        
        assert((0..<size.columns - 2).contains(row), "Row index must lie in [0, size.columns - 2)")
        assert(player.items.count == 8, "Each player must have 8 ghosts")
        
        // Slice assignment won't be work between board and items since they have
        // different Iterator.Element types, so we map items to have a new type of Optional<Ghost>
        let optionalItems = items.map(Optional.init)
        
        let itemsCount = items.count
        let itemsPerRow = itemsCount / 2
        
        let leftRightOffset = (size.columns - itemsPerRow) / 2
        
        var firstRowRange = size.columns * row + leftRightOffset..<size.columns * (row + 1) - leftRightOffset
        var secondRowRange = size.columns * (row + 1) + leftRightOffset..<size.columns * (row + 2) - leftRightOffset
        
        if player === firstPlayer {
            swap(&firstRowRange, &secondRowRange)
        }
        
        board[firstRowRange] = optionalItems[0..<itemsPerRow]
        board[secondRowRange] = optionalItems[itemsPerRow..<itemsCount]
    }
    
}

extension _GhostsGameBoard: CustomStringConvertible {
    
    public var description: String {
        var description = "\(firstPlayer.name)\n"
        
        for i in 0..<size.rows {
            for j in 0..<size.columns {
                let emptyCellDescription: String
                
                if i == 0 || i == size.rows - 1 {
                    if j == 0 {
                        emptyCellDescription = "⬅️"
                    } else if j == size.columns - 1 {
                        emptyCellDescription = "➡️"
                    } else {
                        emptyCellDescription = "⚫️"
                    }
                } else {
                    emptyCellDescription = "⚫️"
                }
                
                if let ghost = board[size.rows * i + j] {
                    description += ghost.description
                } else {
                    description += emptyCellDescription
                }
            }
            
            description += "\n"
        }
        
        description += secondPlayer.name
        
        return description
    }
    
}
