//
//  ViewController.swift
//  Calculator
//
//  Created by Michael Taranik on 31.08.2024.
//

import UIKit

class MainVC: UIViewController {
    
    private lazy var buttonsStack: UIStackView = {
        let firstStack = createStack(with: [
            .clear, .function("+/-"), .function("%"), .operation("/")
        ])
        let secondStack = createStack(with: [
            .number("7"), .number("8"), .number("9"), .operation("*")
        ])
        let thirdStack = createStack(with: [
            .number("4"), .number("5"), .number("6"), .operation("-")
        ])
        let fourthStack = createStack(with: [
            .number("1"), .number("2"), .number("3"), .operation("+")
        ])
        let zeroButton = makeButton(for: .number("0"))
        let decimalButton = makeButton(for: .decimal)
        let equalButton = makeButton(for: .equal)
        let zeroStack = UIStackView(arrangedSubviews: [zeroButton])
        zeroStack.axis = .horizontal
        zeroStack.spacing = 1
        zeroStack.distribution = .fillEqually
        let secondPartOfZeroStack = UIStackView(arrangedSubviews: [decimalButton, equalButton])
        secondPartOfZeroStack.axis = .horizontal
        secondPartOfZeroStack.spacing = 1
        secondPartOfZeroStack.distribution = .fillEqually
        let fifthStack = UIStackView(arrangedSubviews: [zeroStack, secondPartOfZeroStack])
        fifthStack.axis = .horizontal
        fifthStack.spacing = 1
        fifthStack.distribution = .fillEqually
        let stacks: [UIStackView] = [firstStack, secondStack, thirdStack, fourthStack, fifthStack]
        let mainStack = UIStackView(arrangedSubviews: stacks)
        mainStack.axis = .vertical
        mainStack.spacing = 1
        mainStack.distribution = .fillEqually
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        return mainStack
    }()
    
    private lazy var resultText: UITextView = {
        let text = UITextView()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.backgroundColor = .black
        text.text = "0"
        text.font = .systemFont(ofSize: 40)
        text.textAlignment = .right
        text.textColor = .white
        text.isEditable = false
        text.isScrollEnabled = false
        return text
    }()
    
    private var buttonActions: [UIButton: CalculatorButton] = [:]
    private var currentInput: String = ""
    private var previousInput: String = ""
    private var currentOperation: String? = nil
    private var shouldClearDisplay: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setUpViews()
        setUpConstraints()
    }
    
    private func setUpViews() {
        view.addSubview(resultText)
        view.addSubview(buttonsStack)
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            resultText.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            resultText.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            resultText.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            resultText.heightAnchor.constraint(equalToConstant: 200),
            
            buttonsStack.topAnchor.constraint(equalTo: resultText.bottomAnchor),
            buttonsStack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            buttonsStack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            buttonsStack.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func createStack(with buttons: [CalculatorButton]) -> UIStackView {
        let stack = UIStackView(arrangedSubviews: buttons.map(makeButton))
        stack.axis = .horizontal
        stack.spacing = 1
        stack.distribution = .fillEqually
        return stack
    }
    
    private func makeButton(for calculatorButton: CalculatorButton) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(calculatorButton.title, for: .normal)
        button.backgroundColor = calculatorButton.backgroundColor
        button.titleLabel?.font = .systemFont(ofSize: 30)
        button.tintColor = .white
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        
        buttonActions[button] = calculatorButton
        return button
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        guard let button = buttonActions[sender] else { return }
        handleButtonTap(button)
    }
    
    private func handleButtonTap(_ button: CalculatorButton) {
        switch button {
        case .number(let value):
            appendNumber(value)
        case .operation(let symbol):
            setOperation(symbol)
        case .function(let function):
            break
        case .decimal:
            if !resultText.text!.contains(".") {
                resultText.text! += "."
            }
        case .equal:
            calculate()
        case .clear:
            clear()
        }
    }
    
    private func appendNumber(_ number: String) {
        if shouldClearDisplay {
            currentInput = ""
            shouldClearDisplay = false
        }
        currentInput += number
        resultText.text = currentInput
    }

    private func appendDecimal() {
        if shouldClearDisplay {
            currentInput = "0."
            shouldClearDisplay = false
        } else if !currentInput.contains(".") {
            currentInput += "."
        }
        resultText.text = currentInput
    }
    
    private func setOperation(_ operation: String) {
        if !currentInput.isEmpty {
            previousInput = currentInput
            currentInput = ""
            currentOperation = operation
        }
    }
    
    private func calculate() {
        guard let operation = currentOperation,
              let previousValue = Double(previousInput),
              let currentValue = Double(currentInput) else { return }

        var result: Double = 0
        switch operation {
        case "+":
            result = previousValue + currentValue
        case "-":
            result = previousValue - currentValue
        case "*":
            result = previousValue * currentValue
        case "/":
            result = previousValue / currentValue
        default:
            return
        }
        var isIntResult: Bool = false
        if floor(result) == result {
            isIntResult = true
        }
        if isIntResult {
            currentInput = "\(Int(result))"
        } else {
            currentInput = "\(result)"
        }
        resultText.text = currentInput
        previousInput = ""
        currentOperation = nil
        shouldClearDisplay = true
    }
    
    private func clear() {
        currentInput = ""
        previousInput = ""
        currentOperation = nil
        resultText.text = "0"
    }
}
