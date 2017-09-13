import Foundation

public protocol RandomNumberGenerator {
  func random() -> Double
  var initValue: Double { get set }
}

public class LinearCongruentialGenerator: RandomNumberGenerator {
  var lastRandom = 42.0
  let m = 139968.0
  let a = 3877.0
  let c = 29573.0
  public var initValue: Double {
    get{
      return lastRandom
    }
    set(newVal) {
      lastRandom = newVal
    }
  }
  public func random() -> Double {
    lastRandom = ((lastRandom * a + c).truncatingRemainder(dividingBy:m))
    return lastRandom / m
  }
  
}
