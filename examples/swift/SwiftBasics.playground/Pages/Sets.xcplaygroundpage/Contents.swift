/*:
 ## Sets
 [Table of Contents](TableOfContents) · [Previous](@previous) · [Next](@next)
 ****
 */
import Foundation
//: Init empty
var letters = Set<Character>()

let alphabet = "abcdefghijklmnopqrstuvwxyz"
for c in alphabet {
    letters.insert(c)
}
//: Init from sequence
var lorem = Set<Character>("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.")

for c in alphabet {
    lorem.remove(c)
}
lorem

let digits = Set<Character>("1234567890")
let alphanum = letters.union(digits)

digits.union(letters) == alphanum

//: ### Membership
letters.isSubset(of: alphanum)
letters.isStrictSubset(of: alphanum)

letters.isSubset(of: letters)
letters.isStrictSubset(of: letters)

digits.isDisjoint(with: letters)

alphanum.contains("9")
alphanum.isSuperset(of: "0x2a")
//: ### Set Operations
var animals: Set<Character> = ["🐰","🦊","🐻","🐼","🐹"]
animals.intersection("🐰🐱🐶🐻🐙")
animals.symmetricDifference("🐰🐱🐶🐻🐙")
animals.subtracting("🐰🐱🐶🐻🐙")
animals.union("🐰🐱🐶🐻🐙")
//: ****
//:  [Table of Contents](TableOfContents) · [Previous](@previous) · [Next](@next)
