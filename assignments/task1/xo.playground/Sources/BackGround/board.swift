import Foundation

//---------------------------------------
// сущность игрового поля
public protocol Table {
    // доска - массив клеток
    var table : [square] { get set }
    
    // доступ по индексу
    subscript(_ x: Int, _ y: Int) -> kindOfMark { get set };
}

extension Table {
    public subscript(_ x: Int, _ y: Int) -> kindOfMark {
        get{ return table[x * board_size + y].kind }
        set{ table[x * board_size + y].setValue(newValue) }
    }
}
//---------------------------------------


//---------------------------------------

// сущность печатающейся доски, которая умеет себя печатать
public protocol PrintableTable : Table {
    func printTable()
}

extension PrintableTable {
    public func printTable() {
        for i in 0...board_size-1 {
            for j in 0...board_size-1 {
                printType(self[i, j])
            }
            print("")
        }
    }
}
//---------------------------------------

// класс доски(игровое поле)
public class board: PrintableTable {
    // доска
    public var table: [square]
    
    // свободный клетки
    public var freeSquare: [Int]
    
    // инициализация
    public init() {
        table = [square](repeating: square(), count: board_size * board_size)
        freeSquare = [Int]()
        
        for i in 0...(board_size * board_size - 1) {
            self.freeSquare.append(i)
        }
    }
    
}
