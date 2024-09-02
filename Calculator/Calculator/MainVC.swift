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
            .clear, .function("+/-"), .function("%"), .operation("÷")
        ])
        let secondStack = createStack(with: [
            .number("7"), .number("8"), .number("9"), .operation("×")
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
    private lazy var calculatorDisplayText: UITextView = {
        let text = UITextView()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.backgroundColor = .black
        text.text = vm.resultText
        text.font = .systemFont(ofSize: 40)
        text.textAlignment = .right
        text.textColor = .white
        text.isEditable = false
        text.isScrollEnabled = false
        return text
    }()
    private var vm = CalculatorModel()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setUpViews()
        setUpConstraints()
    }
    
    private func setUpViews() {
        view.addSubview(calculatorDisplayText)
        view.addSubview(buttonsStack)
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            calculatorDisplayText.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            calculatorDisplayText.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            calculatorDisplayText.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            calculatorDisplayText.heightAnchor.constraint(equalToConstant: 200),
            
            buttonsStack.topAnchor.constraint(equalTo: calculatorDisplayText.bottomAnchor),
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
        vm.buttonActions[button] = calculatorButton
        return button
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        guard let button = vm.buttonActions[sender] else { return }
        vm.handleButtonTap(button)
        calculatorDisplayText.text = vm.resultText
    }
    
}
