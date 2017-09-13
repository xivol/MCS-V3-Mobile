import Foundation

public protocol PrintableDeligate {
    func toString()->String
}

public protocol Movable {
    func makeMovePlayer(column: Int, player:Bool)
}

public protocol ChekMove {
    func isValidMove (_ column: Int)->Bool
}

public protocol GetWinner {
    func hasWinner()->Bool
    func getWinner()->Int
    func whoWin()->Int
}

extension GetWinner {
    public func hasWinner()->Bool{
        return getWinner() != 0
    }
    public func whoWin()->Int {
        return (getWinner() == 1) ? 1 : 2
    }
}

