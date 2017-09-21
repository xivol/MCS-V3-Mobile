//
//  Calculator.swift
//  calculator
//
//  Created by Илья Лошкарёв on 20.09.17.
//  Copyright © 2017 Илья Лошкарёв. All rights reserved.
//

import Foundation

protocol CalculatorDelegate: class {
    
    // Calculator updated input Value or computed result
    func calculatorDidUpdateValue(_ calculator: Calculator, with value: Double, valuePrecision fractionDigits: UInt)
    
    // Caculator cleared output with default values
    func calculatorDidClear(_ calculator: Calculator, withDefaultValue value: Double?, defaultPrecision fractionDigits: UInt?)
    
    // Input Overflow Error
    func calculatorDidInputOverflow(_ calculator: Calculator)
    // Computational Error
    func calculatorDidNotCompute(_ calculator: Calculator, withError message: String)
}
