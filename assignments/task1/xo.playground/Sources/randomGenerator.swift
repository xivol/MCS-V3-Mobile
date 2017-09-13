import Foundation

// интерфейс произвольного числа в диапазоне
public protocol RandomNumberGenerator {
    func random(maxValue:Int) -> Int
}

public class randomGeneratorXO: RandomNumberGenerator {
    public init() { }
    
    // сгенерировать произвольное число в диапазон от 0 до maxValue
    public func random(maxValue: Int) -> Int {
        return Int(arc4random()) % maxValue
    }
}
