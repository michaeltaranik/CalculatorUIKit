//
//  CalculatorButton.swift
//  Calculator
//
//  Created by Michael Taranik on 01.09.2024.
//

import UIKit

enum CalculatorButton: Equatable {
    case number(String)
    case operation(String)
    case function(String)
    case decimal
    case equal
    case clear
    
    var title: String {
        switch self {
        case .number(let value): return value
        case .operation(let symbol): return symbol
        case .function(let symbol): return symbol
        case .decimal: return "."
        case .equal: return "="
        case .clear: return "AC"
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .number, .decimal: return .darkGray
        case .operation, .equal: return .systemOrange
        case .function, .clear: return .gray
        }
    }
}

