/*:
 ## Arrays
 [Table of Contents](TableOfContents) · [Previous](@previous) · [Next](@next)
 ****
 
 */
var fibonachi: [Int] = [1,2,3,5,8]

while fibonachi.count < 20 {
    fibonachi.append(fibonachi.last! + fibonachi[fibonachi.count-2])
}
fibonachi

fibonachi.insert(1, at: 0)
fibonachi.remove(at: 1)

//: ### Slicing Arrays
fibonachi[10...14]
fibonachi.prefix(upTo: 10)
fibonachi.suffix(from: 10)
//: ### Searching Arrays
fibonachi.index(of: 377)
if let ind = fibonachi.index(where: {
    elem in
    return elem > 99 && elem < 1000
}) {
    fibonachi[ind]
}
//: ### Spliting Arrays
fibonachi.split(separator: 89)
fibonachi.split(whereSeparator: {
    $0 % 2 == 0
})
/*:
 ### Processing Arrays
 Sequences and collections implement methods such as `map(_:)`, `filter(_:)`, and `reduce(_:_:)` to consume and transform their contents. You can compose these methods together to efficiently implement complex algorithms.

 A collection's `filter(_:)` method returns an array containing only the elements that pass the provided test.
*/
fibonachi.filter({
    elem in
    elem % 2 == 0
})

var fibStrings = fibonachi.map({
    "\( $0 )"
})
fibStrings.insert("?", at: 0)

//: The `map(_:)` method returns a new array by applying a `transform` to each element in a collection.
fibStrings.map({
    Int($0)
})
//: The `flatMap(_:)` method works similar to `map(_:)` but the result contains only non-nil values.
fibStrings.compactMap(Int.init(_:))

//: `reduce(_:,_:)`
fibonachi[0...5].reduce(1, {
    sum, elem in
    sum * elem
})

fibonachi[0...5].reduce(0) {
    $0 + $1
}
//: - Experiment: Every divider of first 20 fibonachi numbers.
var dividers: [Int:[Int]] = [:]
fibonachi.forEach {
    fib in
    if fib > 2 {
        dividers[fib] = (2..<fib).filter {fib % $0 == 0}
    } else {
       dividers[fib] = []
    }
}
dividers
//: ****
//: [Table of Contents](TableOfContents) · [Previous](@previous) · [Next](@next)
