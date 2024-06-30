//
//  ViewController.swift
//  Password-Reset
//
//  Created by 藤門莉生 on 2024/06/29.
//

import UIKit

class ViewController: UIViewController {

    private let stackView = UIStackView()
    private let newPasswordTextField = PasswordTextField(placeholderText: "New password")
    private let criteriaView = PasswordCriteriaView(text: "uppercase letter (A-Z)")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        style()
        layout()
    }
}

private extension ViewController {
    func style() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 20
        
        newPasswordTextField.translatesAutoresizingMaskIntoConstraints = false
        criteriaView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func layout() {
        // stackView.addArrangedSubview(newPasswordTextField)
        stackView.addArrangedSubview(criteriaView)

        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: stackView.trailingAnchor, multiplier: 2),
        ])
    }
}
