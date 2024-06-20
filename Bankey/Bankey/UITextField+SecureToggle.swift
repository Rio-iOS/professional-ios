//
//  UITextField+SecureToggle.swift
//  Bankey
//
//  Created by 藤門莉生 on 2024/06/21.
//

import Foundation
import UIKit

let passwordToggleButton = UIButton(type: .custom)

extension UITextField {
    func enablePasswordToggle() {
        passwordToggleButton.setImage(UIImage(systemName: "eye.fill"), for: .normal)
        passwordToggleButton.setImage(UIImage(systemName: "eye.slash.fill"), for: .selected)
        passwordToggleButton.addTarget(self, action: #selector(togglePasswordView), for: .touchUpInside)
        rightView = passwordToggleButton
        rightViewMode = .always
    }
}

private extension UITextField {
    @objc func togglePasswordView() {
        isSecureTextEntry.toggle()
        passwordToggleButton.isSelected.toggle()
    }
}
