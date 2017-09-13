import Foundation

public class RandomStep {
  let generator: RandomNumberGenerator
  
  public init(initValue: Double, generator: RandomNumberGenerator) {
    self.generator = generator
    self.generator.initValue = initValue
  }
  
  public func roll() -> (Int, Int) {
    return (Int(generator.random() * 9.0), Int(generator.random() * 9.0))
  }
}
