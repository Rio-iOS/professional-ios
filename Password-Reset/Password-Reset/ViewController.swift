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
    private let statusView = PasswordStatusView()
    private let resetButton = UIButton(type: .system)
    
    let newPasswordTextField = PasswordTextField(placeholderText: "New password")
    let confirmPasswordTextField = PasswordTextField(placeholderText: "Re-enter new password")
    var alert: UIAlertController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        style()
        layout()
        setupKeyboardHiding()
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
        resetButton.addTarget(self, action: #selector(resetPasswordButtonTapped), for: .primaryActionTriggered)
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
    
    func setupKeyboardHiding() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func showAlert(title: String, message: String) {
        alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
        guard let alert else { return }
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        alert.title = title
        alert.message = message
        present(alert, animated: true, completion: nil)
    }
}

private extension ViewController {
    @objc func viewTapped(_ recognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(sender: NSNotification) {
        // view.frame.origin.y = view.frame.origin.y - 200
        guard
            let userInfo = sender.userInfo,
            let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
            let currentTextField = UIResponder.currentFirst() as? UITextField
        else {
            return
        }
        
        print("✅userInfo: \(userInfo)")
        print("✅keyboardFrame: \(keyboardFrame)")
        print("✅currentTextField: \(currentTextField)")

        print("✅ currentTextFieldFrame.frame: \(currentTextField.frame)")
        let keyboardTopY = keyboardFrame.cgRectValue.origin.y
        // SuperViewからみたTextFieldのframe座標に変換
        let convertedTextFieldFrame = view.convert(currentTextField.frame, from: currentTextField.superview)
        let textFieldBottomY = convertedTextFieldFrame.origin.y + convertedTextFieldFrame.size.height
        print("✅ convertedTextFieldFrame: \(convertedTextFieldFrame)")

        print("✅ keyboardTopY: \(keyboardTopY)")
        print("✅ textFieldBottomY: \(textFieldBottomY)")
        if textFieldBottomY > keyboardTopY {
            let textBoxY = convertedTextFieldFrame.origin.y
            // let newFrameY = (textBoxY - keyboardTopY / 2) * -1
            let newFrameY = (textBoxY - keyboardTopY) * -1
            view.frame.origin.y = newFrameY
        }
        
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        view.frame.origin.y = 0
    }
}

extension ViewController {
    @objc func resetPasswordButtonTapped(sender: UIButton) {
        view.endEditing(true)
        
        let isValidNewPassword = newPasswordTextField.validate()
        let isValidConfirmPassword = confirmPasswordTextField.validate()
        
        if isValidNewPassword && isValidConfirmPassword {
            showAlert(title: "Success", message: "You have successfully changed your password.")
        }
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

// MARK: Tests
extension ViewController {
    var newPasswordText: String? {
        get { newPasswordTextField.text }
        set { newPasswordTextField.text = newValue }
    }
    
    var confirmPasswordText: String? {
        get { confirmPasswordTextField.text }
        set { confirmPasswordTextField.text = newValue }
    }
}
