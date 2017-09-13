import Foundation

// размер доски
let board_size = 4

// необходимо собрать
let need_to_collect = 5

// тип состояния у клетки
public enum kindOfMark {
    case X
    case O
    case empty
}

// печать символа, в зависимости от состояния клетки на поле
public func getType(_ k : kindOfMark) -> String {
    switch k {
    case .X:
        return "x"
    case .O:
        return "o"
    default:
        return "-"
    }

}

// действие игрока
public enum playerAction {
    case win
    case move(Int, Int, kindOfMark)
    case draw
}

// отображение символа доски
public func printType(_ k: kindOfMark) {
        print(getType(k), terminator:" ")
}
