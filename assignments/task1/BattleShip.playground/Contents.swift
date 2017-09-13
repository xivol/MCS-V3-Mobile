//: __Battleship__ —  (also Battleships or Sea Battle) is a guessing game for two players. It is played on ruled grids (paper or board) on which the players' fleets of ships (including battleships) are marked. The locations of the fleet are concealed from the other player. Players alternate turns calling "shots" at the other player's ships, and the objective of the game is to destroy the opposing player's fleet. Battleship is known worldwide as a pencil and paper game which dates from World War I. It was published by various companies as a pad-and-pencil game in the 1930s, and was released as a plastic board game by Milton Bradley in 1967. The game has spawned electronic versions, video games, smart device apps and a film. __NOTE__ : This version of BattleShip is implemented based on X and Y axis coordinates in range 0-9.

//:
//: ![BattleShip](BattleShip.jpg)

var ship11: CombatShip = CombatShip([(0,0), (0,1), (0,2)])
var ship12: CombatShip = CombatShip([(5,5), (4,5), (3,5), (2,5), (1,5)])
var ship13: CombatShip = CombatShip([(7,3), (7,4), (7,5)])
var jackSparrow: BattleShipPlayer =
  BattleShipPlayer(name: "Jack Sparrow", [ship11, ship12, ship13])

var ship21: CombatShip = CombatShip([(9, 9), (9,8), (9,7)])
var ship22: CombatShip = CombatShip([(5,5), (4,5), (3,5)])
var ship23: CombatShip = CombatShip([(7,5), (7,6), (7,7), (7,8)])
var davyJones: BattleShipPlayer =
  BattleShipPlayer(name: "Davy Jones", [ship21, ship22, ship23])

var game = BattleShip()

game.delegate = BattleShipTracker()

game.join(player: jackSparrow)
game.join(player: davyJones)

game.play()
