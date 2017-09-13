import Foundation

public protocol BoardProt: PrintableDeligate, Movable, ChekMove, GetWinner {}
public protocol BoardDelegate: MultiplayerGameDelegate {}

public class Board: BoardProt {
    public let name = "Connect 4"
    public var delegate: BoardDelegate?
    let player1 = 1
    let player2 = 2
    let nobody = 0
    var height, width, winlength: Int
    var board : [[Int]]
    var columnCounts = Array<Int> ()
    
    public init (height: Int, width: Int, winlength: Int) {
        self.height = height
        self.width = width
        self.winlength = winlength
        board = [[Int]](repeating:[Int](repeating:0,count:height), count:width)
        for _ in 1...width {
            columnCounts.append(0)
        }
    }
    
    public var players: [Player] = [BoardPlayer]()
    
    public func join (player: Player){
    }
    
    
    
    public func isValidMove(_ column: Int)->Bool{
        return (columnCounts[column] < height)
    }
    
    public func makeMovePlayer(column: Int, player: Bool) {
        makeMove(column: column, player: player)
    }
    
    public func makeMove(column: Int, player: Bool){
        if isValidMove(column) {
            let sign = player ? player1:player2
            board[column][columnCounts[column]] = sign
            columnCounts[column] += 1
        }
    }
    
    public func getWidth()->Int {
        return width
    }
    
    public func toString()->String {
        let numbers = [" 1️⃣ ", " 2️⃣ ", " 3️⃣ ", " 4️⃣ ", " 5️⃣ ", " 6️⃣ ", " 7️⃣ ", " 8️⃣ ", " 9️⃣ ", " 🔟 "]
        var res = ""
        for x in 0..<width {
            res += numbers[x]
        }
        res += "\n"
        for y in stride(from: height-1, to: -1, by: -1) {
            for x in 0..<width {
                if(board[x][y]==player1){
                    res += " 🔴 "
                }
                else if(board[x][y]==player2){
                    res += " 🔵 "
                }
                else {
                    res += " ⚫️ "
                }
            }
            res += "\n"
        }
        return res
    }
    
    public func getWinner()->Int {
        
        for x in 0..<width {
            for y in 0...(height-winlength) {
                var player1Win = true
                var player2Win = true
                for i in 0..<winlength {
                    if (player1Win && board[x][y + i] != player1){
                        player1Win = false
                    }
                    if (player2Win && board[x][y + i] != player2){
                        player2Win = false
                    }
                }
                if(player1Win){
                    return player1
                }
                else if(player2Win){
                    return player2
                }
            }
        }
        
        for y in 0..<height {
            for x in 0...(width-winlength) {
                var player1Win = true
                var player2Win = true
                for i in 0..<winlength {
                    if (player1Win && board[x+i][y] != player1){
                        player1Win = false
                    }
                    if (player2Win && board[x+i][y] != player2){
                        player2Win = false
                    }
                }
                if(player1Win){
                    return player1
                }
                else if(player2Win){
                    return player2
                }
            }
        }
        
        for x in 0...(width-winlength){
            for y in 0...(height-winlength){
                var player1Win = true
                var player2Win = true
                for i in 0..<winlength {
                    if (player1Win && board[x+i][y+i] != player1){
                        player1Win = false
                    }
                    if (player2Win && board[x+i][y+i] != player2){
                        player2Win = false
                    }
                }
                if(player1Win){
                    return player1
                }
                else if(player2Win){
                    return player2
                }
            }
        }
        
        for x in stride(from: width-1, to: winlength-2, by: -1){
            for y in 0...(height-winlength) {
                var player1Win = true
                var player2Win = true
                for i in 0..<winlength {
                    if (player1Win && board[x-i][y+i] != player1){
                        player1Win = false
                    }
                    if (player2Win && board[x-i][y+i] != player2){
                        player2Win = false
                    }
                }
                if(player1Win){
                    return player1
                }
                else if(player2Win){
                    return player2
                }
            }
        }
        
     return nobody
    }
    
}
