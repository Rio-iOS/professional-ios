//
//  PasswordCriteriaView.swift
//  Password-Reset
//
//  Created by 藤門莉生 on 2024/06/30.
//

import Foundation
import UIKit

class PasswordCriteriaView: UIView {
    private let stackView = UIStackView()
    private let imageView = UIImageView()
    private let label = UILabel()
    
    private let checkmarkImage = UIImage(systemName: "checkmark.circle")?.withTintColor(.systemGreen, renderingMode: .alwaysOriginal)
    private let xmarkImage = UIImage(systemName: "xmark.circle")?.withTintColor(.systemRed, renderingMode: .alwaysOriginal)
    private let circleImage = UIImage(systemName: "circle")?.withTintColor(.tertiaryLabel, renderingMode: .alwaysOriginal)
   
    var isCriteriaMet: Bool = false {
        didSet {
            if isCriteriaMet {
                imageView.image = checkmarkImage
            } else {
                imageView.image = xmarkImage
            }
        }
    }
    
    init(text: String) {
        super.init(frame: .zero)
        
        label.text = text
        
        style()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var intrinsicContentSize: CGSize {
        CGSize(width: 200, height: 40)
    }
    
    func reset() {
        isCriteriaMet = false
        imageView.image = circleImage
    }
}

private extension PasswordCriteriaView {
    func style() {
        translatesAutoresizingMaskIntoConstraints = false
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 8
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "circle")?.withTintColor(.tertiaryLabel, renderingMode: .alwaysOriginal)
    
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .secondaryLabel
    }
    
    func layout() {
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(label)
        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
        ])
        imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        NSLayoutConstraint.activate([
            
        ])
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
    }
}

// MARK: Tests
extension PasswordCriteriaView {
    var isCheckMarkImage: Bool {
        imageView.image == checkmarkImage
    }
    
    var isXmarkImage: Bool {
        imageView.image == xmarkImage
    }
    
    var isResetImage: Bool {
        imageView.image == circleImage
    }
}
