/*:
 # Ghosts
 
 Ghosts is a board game designed by Alex Randolph for two players, released in 1982 by Milton Bradley
 
 ![](1.jpg)
 
 This is a board game for two players. It tooks place on a board of size 6x6. The main 
 game items are ghosts. Ghost can be a good-spirited which is marked with a blue color and a bad-spirited which is marked red color. Each player has 8 ghosts: 4 blue and 4 red. Players place their ghosts on the board four per line starting from the first one, since the ghosts marks are placed behind each ghost players don't know exactly where are good and bad ones ghosts of their opponent.
 
![](2.jpg)
 
 Ghost can be moved in a four ways: forward, backward, left, right. It can be never moved diagonally. On each cell can be only one ghost at time. You can capture opponent's ghosts by moving to the cell with his ghost. But capturing isn't required, it's an optional feature. Captured ghosts are removed from the board.
 
 ### How To Win
 
 - Capture opponent's four good-spirited ghosts
 - Indice opponent to capture your four bad-spirited ghosts
 - Have one of your own ghosts escape through an opponent's corner square
 
 Read about **Ghosts** on [Wikipedia](https://en.wikipedia.org/wiki/Ghosts_(board_game))
 
*/

let firstPlayerGhosts = [
    Ghost(marker: .red),
    Ghost(marker: .red),
    Ghost(marker: .red),
    Ghost(marker: .red),
    Ghost(marker: .blue),
    Ghost(marker: .blue),
    Ghost(marker: .blue),
    Ghost(marker: .blue)
]

let secondPlayerGhosts = [
    Ghost(marker: .blue),
    Ghost(marker: .blue),
    Ghost(marker: .blue),
    Ghost(marker: .blue),
    Ghost(marker: .red),
    Ghost(marker: .red),
    Ghost(marker: .red),
    Ghost(marker: .red)
]

let firstPlayer = GhostsPlayer(name: "Mike", items: firstPlayerGhosts)
let secondPlayer = GhostsPlayer(name: "John", items: secondPlayerGhosts)

var gameBoard = _GhostsGameBoard(size: (6, 6),
                                 firstPlayer: firstPlayer,
                                 secondPlayer: secondPlayer)

let ghosts = Ghosts(firstPlayer: firstPlayer,
                    secondPlayer: secondPlayer,
                    gameBoard: gameBoard)

let ghostsSessionLogger = GhostsSessionLogger()
ghosts.delegate = ghostsSessionLogger

ghosts.play()
