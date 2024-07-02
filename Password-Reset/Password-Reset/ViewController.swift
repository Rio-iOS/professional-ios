//
//  ViewController.swift
//  Password-Reset
//
//  Created by 藤門莉生 on 2024/06/29.
//

import UIKit

class ViewController: UIViewController {
    typealias CustomValidation = PasswordTextField.CustomValidation
    
    private let stackView = UIStackView()
    private let newPasswordTextField = PasswordTextField(placeholderText: "New password")
    private let statusView = PasswordStatusView()
    private let confirmPasswordTextField = PasswordTextField(placeholderText: "Re-enter new password")
    private let resetButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        style()
        layout()
    }
}

private extension ViewController {
    func setup() {
        setupNewPassword()
        setupConfirmPassword()
        setupDismissKeyboardGesture()
    }
    
    func setupNewPassword() {
        let newPasswordValidation: CustomValidation = { text in
            // Empty text
            guard let text, !text.isEmpty else {
                self.statusView.reset()
                return (false, "Enter your password")
            }
            
            // Valid characters
            let validChars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.,@:?!()$\\/#"
            let invalidSet = CharacterSet(charactersIn: validChars).inverted
            guard text.rangeOfCharacter(from: invalidSet) == nil else {
                return (false, "Enter valid special chars （.,@:?!()$\\/#）with no spaces")
            }
            
            // Criteria met
            self.statusView.updateDisplay(text)
            if !self.statusView.validate(text) {
                return (false, "Your password must meet the requirements below")
            }
            
            return (true, "")
        }
        
        newPasswordTextField.customValidation = newPasswordValidation
    }
    
    func setupConfirmPassword() {
        let confirmPasswordValidation: CustomValidation = { text in
            guard let text, !text.isEmpty else {
                return (false, "Enter your password")
            }
            
            guard text == self.newPasswordTextField.text else {
                return (false, "Password do not match")
            }
            
            return (true, "")
        }
        
        confirmPasswordTextField.customValidation = confirmPasswordValidation
        confirmPasswordTextField.delegate = self
    }
    
    func style() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 20
        
        newPasswordTextField.translatesAutoresizingMaskIntoConstraints = false
        newPasswordTextField.delegate = self
        confirmPasswordTextField.translatesAutoresizingMaskIntoConstraints = false
        
        statusView.translatesAutoresizingMaskIntoConstraints = false
        statusView.layer.cornerRadius = 5
        statusView.clipsToBounds = true
        
        resetButton.translatesAutoresizingMaskIntoConstraints = false
        resetButton.configuration = .filled()
        resetButton.setTitle("Reset password", for: [])
        // resetButton.addTarget(self, action: #selector(resetPasswordButtonTapped), for: .primaryActionTriggered)
    }
    
    func layout() {
        stackView.addArrangedSubview(newPasswordTextField)
        stackView.addArrangedSubview(statusView)
        stackView.addArrangedSubview(confirmPasswordTextField)
        stackView.addArrangedSubview(resetButton)

        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: stackView.trailingAnchor, multiplier: 2),
        ])
    }
    
    func setupDismissKeyboardGesture() {
        let dismissKeyboardTap = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:)))
        view.addGestureRecognizer(dismissKeyboardTap)
    }
}

private extension ViewController {
    @objc func viewTapped(_ recognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}

extension ViewController: PasswordTextFieldDelegate {
    func editingChanged(_ sender: PasswordTextField) {
        if sender === newPasswordTextField {
            statusView.updateDisplay(sender.text ?? "")
        }
    }
    
    func editingDidEnd(_ sender: PasswordTextField) {
        if sender === newPasswordTextField {
            statusView.shouldResetCriteria = false
            _ = newPasswordTextField.validate()
        } else if sender === confirmPasswordTextField {
            _ = confirmPasswordTextField.validate()
        }
    }
}
