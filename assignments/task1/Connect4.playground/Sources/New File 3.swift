import Foundation

public func getInput(from: Int, to: Int, number:Int)->Int {
    var res = 0
    while (res < from || res > to) {
        res = number
    }
    return res
}

public func step(name:String, t: inout Bool, c: inout Int, b: inout Board){
    repeat{
        t = true
        for i in 0...b.getWidth()-1 {
            t = t && !b.isValidMove(i)
        }
        if(t){
            break
        }
        let move = Int(arc4random_uniform(7) + 1)
        print("\(name) move is: \(move)\n")
        c = getInput(from: 1, to: b.getWidth(), number: move) - 1
        if(!b.isValidMove(c)){
            print("You cannot place in this column!\n")
        }
        
    }while(!b.isValidMove(c))
    
    b.makeMovePlayer(column: c, player: (name == "Andrew"))
}


public func main() {
    print("The game is Connect Four! Good Luck!\n")
    print("The game starts: ")
    let randPlayer = Int(arc4random_uniform(2))
    var turn = randPlayer==0 ? true:false
    var column = 0
    var tie = false
    var board = Board(height: 6, width: 7, winlength: 4)
    if(turn){
        print("Andrew move is the first\n")
    }
    else {
        print("John move is the first\n")
    }
    while(!tie && !board.hasWinner()) {
        print(board.toString())
        if(turn){
            step(name:"Andrew", t: &tie, c: &column, b: &board)
        }
        else{
            step(name: "John", t: &tie, c: &column, b: &board)
        }
        turn = !turn
    }
    print()
    print(board.toString())
    if(tie){
        print("It's a tie")
        return
    }
    board.whoWin() == 1 ? print("Andrew win") : print("John win")
    
}
