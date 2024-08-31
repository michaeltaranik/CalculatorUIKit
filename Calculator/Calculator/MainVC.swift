//
//  ViewController.swift
//  Calculator
//
//  Created by Michael Taranik on 31.08.2024.
//

import UIKit

class MainVC: UIViewController {
    
    
    private let numbers: [String] = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "."]
    
    private let operators: [String] = ["+", "-", "*", "/", "="]
    
    private let editOperatos: [String] = ["AC", "+/-", "%"]
    
    private lazy var numberButtons: [UIButton] = numbers.map(\.self).map(createCalcButton)
    
    private lazy var operatorButtons: [UIButton] = operators.map(\.self).map(createCalcButton)
    
    private lazy var editOperatorButtons: [UIButton] = editOperatos.map(\.self).map(createCalcButton)
    
    private lazy var operatorStack: UIStackView = {
        let orangeButtons = operatorButtons.map {
            let button = $0
            button.backgroundColor = .systemOrange
            return button
        }
        let opstack = UIStackView(arrangedSubviews: orangeButtons)
        opstack.translatesAutoresizingMaskIntoConstraints = false
        opstack.axis = .vertical
        opstack.spacing = 1
        opstack.distribution = .fillEqually
        return opstack
    }()

    private lazy var numStack: UIStackView = {
        let lowStack = UIStackView(arrangedSubviews: [numberButtons[1], numberButtons[2], numberButtons[3]])
        let midStack = UIStackView(arrangedSubviews: [numberButtons[4], numberButtons[5], numberButtons[6]])
        let highStack = UIStackView(arrangedSubviews: [numberButtons[7], numberButtons[8], numberButtons[9]])
        let dot = UIStackView(arrangedSubviews: [numberButtons[10]])
        let zeroStack = UIStackView(arrangedSubviews: [numberButtons[0], dot])
        dot.translatesAutoresizingMaskIntoConstraints = false
        dot.widthAnchor.constraint(equalTo: zeroStack.widthAnchor, multiplier: 0.330).isActive = true
        zeroStack.axis = .horizontal
        zeroStack.spacing = 1
        let opStack = UIStackView(arrangedSubviews: editOperatorButtons)
        for stack in [lowStack, midStack, highStack, opStack] {
            stack.axis = .horizontal
            stack.spacing = 1
            stack.distribution = .fillEqually
        }
        let numStack = UIStackView(arrangedSubviews: [opStack, highStack, midStack, lowStack, zeroStack])
        numStack.translatesAutoresizingMaskIntoConstraints = false
        numStack.axis = .vertical
        numStack.spacing = 1
        numStack.distribution = .fillEqually
        return numStack
    }()
    
    private lazy var buttonsStack: UIStackView = {
        let buttonStack = UIStackView(arrangedSubviews: [numStack, operatorStack])
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        buttonStack.axis = .horizontal
        buttonStack.spacing = 1
        return buttonStack
    }()
    
    private lazy var resultText: UITextView = {
        let text = UITextView()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.backgroundColor = .black
        text.text = "0"
        text.font = .systemFont(ofSize: .init(40))
        text.textAlignment = .right
        text.textColor = .white
        text.isEditable = false
        text.isScrollEnabled = false
        return text
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setUpViews()
        setUpConstrants()
    }
    
    
    private func setUpViews() {
        view.addSubview(resultText)
        view.addSubview(buttonsStack)
    }
    
    private func setUpConstrants() {
        NSLayoutConstraint.activate([
            resultText.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            resultText.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            resultText.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            resultText.heightAnchor.constraint(equalToConstant: 200),
            
            buttonsStack.topAnchor.constraint(equalTo: resultText.bottomAnchor),
            buttonsStack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            buttonsStack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            buttonsStack.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
//            numStack.widthAnchor.constraint(equalTo: buttonsStack.widthAnchor, multiplier: 0.74),
            operatorStack.widthAnchor.constraint(equalTo: buttonsStack.widthAnchor, multiplier: 0.25),
        ])
    }
    
    
    
    
    
    
    
    
    private func createCalcButton(_ sign: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(sign, for: .normal)
        button.addTarget(self, action: #selector(numberTapped), for: .touchUpInside)
        button.backgroundColor = .darkGray
        button.titleLabel?.font = .systemFont(ofSize: .init(30))
        button.tintColor = .white
        return button
    }
    
    
    @objc private func numberTapped(_ sender: UIButton) {
        print(sender.title(for: .normal)!)
        self.resultText.text += sender.title(for: .normal)!
    }
    
}

