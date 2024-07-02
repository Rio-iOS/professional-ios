//
//  PasswordTextField.swift
//  Password-Reset
//
//  Created by 藤門莉生 on 2024/06/29.
//

import UIKit

protocol PasswordTextFieldDelegate: AnyObject {
    func editingChanged(_ sender: PasswordTextField)
    func editingDidEnd(_ sender: PasswordTextField)
}

class PasswordTextField: UIView {

    typealias CustomValidation = (_ textValue: String?) -> (Bool, String)?
    
    private let textField = UITextField()
    private let lockImageView = UIImageView(image: .init(systemName: "lock.fill"))
    private let placeholderText: String
    private let eyeButton = UIButton(type: .custom)
    private let divider = UIView()
    private let errorMessageLabel = UILabel()
   
    var text: String? {
        get { textField.text }
        set { textField.text = newValue }
    }
    
    var customValidation: CustomValidation?
    weak var delegate: PasswordTextFieldDelegate?
    
    init(placeholderText: String) {
        self.placeholderText = placeholderText
        
        super.init(frame: .zero)

        style()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: 200, height: 50)
    }
}

private extension PasswordTextField {
    func style() {
        translatesAutoresizingMaskIntoConstraints = false
        
        lockImageView.translatesAutoresizingMaskIntoConstraints = false
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.isSecureTextEntry = true
        textField.placeholder = placeholderText
        textField.delegate = self
        textField.keyboardType = .asciiCapable
        textField.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [
            NSAttributedString.Key.foregroundColor: UIColor.secondaryLabel
        ])
        textField.addTarget(self, action: #selector(textFieldEditingChanged), for: .editingChanged)
        
        eyeButton.translatesAutoresizingMaskIntoConstraints = false
        eyeButton.setImage(UIImage(systemName: "eye.circle"), for: .normal)
        eyeButton.setImage(UIImage(systemName: "eye.slash.circle"), for: .selected)
        eyeButton.addTarget(self, action: #selector(togglePasswordView), for: .touchUpInside)
        
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.backgroundColor = .separator
       
        errorMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        errorMessageLabel.font = .preferredFont(forTextStyle: .footnote)
        errorMessageLabel.text = "Your password must meet the requirements below."
        errorMessageLabel.textColor = .systemRed
        // 文字サイズを合わせる場合
        // errorMessageLabel.adjustsFontSizeToFitWidth = true
        // errorMessageLabel.minimumScaleFactor = 0.0
        // 改行する場合
        errorMessageLabel.numberOfLines = 0
        errorMessageLabel.lineBreakMode = .byWordWrapping
        errorMessageLabel.isHidden = true

    }
    
    func layout() {
        addSubview(lockImageView)
        addSubview(textField)
        addSubview(eyeButton)
        addSubview(divider)
        addSubview(errorMessageLabel)
       
        NSLayoutConstraint.activate([
            lockImageView.topAnchor.constraint(equalTo: topAnchor),
            lockImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
        ])
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: topAnchor),
            textField.leadingAnchor.constraint(equalToSystemSpacingAfter: lockImageView.trailingAnchor, multiplier: 1)
        ])
        
        NSLayoutConstraint.activate([
            eyeButton.centerYAnchor.constraint(equalTo: textField.centerYAnchor),
            eyeButton.topAnchor.constraint(equalTo: topAnchor),
            eyeButton.leadingAnchor.constraint(equalToSystemSpacingAfter: textField.trailingAnchor, multiplier: 1),
            eyeButton.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        // CHCR
        lockImageView.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: .horizontal)
        textField.setContentHuggingPriority(UILayoutPriority.defaultLow, for: .horizontal)
        eyeButton.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: .horizontal)
        
        NSLayoutConstraint.activate([
            divider.heightAnchor.constraint(equalToConstant: 1),
            divider.topAnchor.constraint(equalToSystemSpacingBelow: textField.bottomAnchor, multiplier: 1),
            divider.leadingAnchor.constraint(equalTo: leadingAnchor),
            divider.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            errorMessageLabel.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: 4),
            errorMessageLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            errorMessageLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
    
    func showError(_ errorMessage: String) {
        errorMessageLabel.isHidden = false
        errorMessageLabel.text = errorMessage
    }
    
    func clearError() {
        errorMessageLabel.isHidden = true
        errorMessageLabel.text = ""
    }
}

private extension PasswordTextField {
    @objc func togglePasswordView(_ sender: Any) {
        textField.isSecureTextEntry.toggle()
        eyeButton.isSelected.toggle()
    }
    
    @objc func textFieldEditingChanged(_ sender: UITextField) {
        delegate?.editingChanged(self)
    }
}

extension PasswordTextField {
    func validate() -> Bool {
        if let customValidation = customValidation,
           let customValidationResult = customValidation(text),
           customValidationResult.0 == false {
            showError(customValidationResult.1)
            return false
        }
        clearError()
        return true
    }
}

// MARK: UITextFieldDelegate
extension PasswordTextField: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.editingDidEnd(self)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
}
