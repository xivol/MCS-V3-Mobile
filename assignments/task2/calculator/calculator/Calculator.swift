//
//  Calculator.swift
//  calculator
//
//  Created by Илья Лошкарёв on 21.09.17.
//  Copyright © 2017 Илья Лошкарёв. All rights reserved.
//

import Foundation

enum Operation: String {
    case add = "+",
    sub = "-",
    mul = "×",
    div = "÷",
    sign = "±",
    perc = "%"
}

protocol Calculator: class {
    var delegate: CalculatorDelegate? { get set }
    
    init(inputLength len: UInt, fractionLength frac: UInt)
    
    func addDigit(_ d: Int)  // add digit to right value
    func addPoint()          // add point to right value
    func addOperation(_ op: Operation)  // add operation
    
    func compute()  // calculate result
    func clear();   // clear right value
    func reset();   // clear all data
    
    var result: Double? { get }  // current left value
    var input: Double? { get }   // current right value
    
    var hasPoint: Bool { get }  // current right value has point
    
    var fractionDigits: UInt { get }  // number of fraction digits in the right value
}
