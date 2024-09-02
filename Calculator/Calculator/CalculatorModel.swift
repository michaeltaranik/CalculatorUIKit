//
//  CalculatorModel.swift
//  Calculator
//
//  Created by Michael Taranik on 02.09.2024.
//

import UIKit


struct CalculatorModel {
    
    private var currentInput: String = "0"
    private var previousInput: String = "0"
    private var currentOperation: String? = nil
    private var shouldClearDisplay: Bool = false
    var buttonActions: [UIButton: CalculatorButton] = [:]
    var resultText: String = "0"
    
    mutating func handleButtonTap(_ button: CalculatorButton) {
        switch button {
        case .number(let value):
            appendNumber(value)
        case .decimal:
            appendDecimal()
        case .operation(let symbol):
            setOperation(symbol)
        case .function(let function):
            executeFunction(function)
        case .equal:
            calculate()
        case .clear:
            clear()
        }
    }
    
    
    mutating func appendNumber(_ number: String) {
        if currentInput == "0" {
            currentInput = number
        } else {
            currentInput += number
        }
        resultText = currentInput
    }

    mutating func appendDecimal() {
        guard !currentInput.contains(".") else { return }
        currentInput += "."
        resultText = currentInput
    }
    
    
    mutating func setOperation(_ operation: String) {
        previousInput = currentInput
        currentInput = "0"
        currentOperation = operation
    }
    
    mutating func executeFunction(_ function: String) {
        switch function {
        case "+/-":
            guard let value = Double(currentInput) else { return }
            guard value != 0 else { return }
            let result = value * -1
            currentInput = roundNumber(result: String(format: "%.5f",result))
            resultText = currentInput
        case "%":
            guard let value = Double(currentInput) else { return }
            let result = value * 0.01
            currentInput = roundNumber(result: String(format: "%.5f",result))
            resultText = currentInput
        default:
            break
        }
    }
    
    mutating func calculate() {
        guard let operation = currentOperation else { return }
        let prev = Double(previousInput) ?? 0
        let curr = Double(currentInput) ?? 0
        var result: Double = 0
        switch operation {
        case "+":
            result = prev + curr
        case "-":
            result = prev - curr
        case "*":
            result = prev * curr
        case "/":
            guard curr != 0 else {
                resultText = "Division by zero"
                return
            }
            result = prev / curr
        default:
            return
        }
        print(result)
        currentInput = roundNumber(result: String(format: "%.5f",result))
        resultText = currentInput
        currentOperation = nil
    }
    
    func roundNumber(result: String) -> String {
        var trimmed = result
        var last = trimmed.last
        while last == "0" && !trimmed.isEmpty {
            trimmed.removeLast()
            last = trimmed.last
        }
        if trimmed.last == "." { trimmed.removeLast() }
        if trimmed.isEmpty || trimmed == "-0.0" || trimmed == "-0"{ return "0" }
        return String(trimmed)
        
    }
    
    mutating func clear() {
        currentInput = ""
        previousInput = ""
        currentOperation = nil
        resultText = "0"
    }
}
