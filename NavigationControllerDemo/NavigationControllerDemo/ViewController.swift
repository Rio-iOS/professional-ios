//
//  ViewController.swift
//  NavigationControllerDemo
//
//  Created by 藤門莉生 on 2024/06/15.
//

import UIKit

class ViewController: UIViewController {
    private let stackView = UIStackView()
    private let pushButton = UIButton(type: .system)
    private let presentButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        layout()
    }
}

private extension ViewController {
    func style() {
        title = "NavBar Demo"
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 20
        
        pushButton.translatesAutoresizingMaskIntoConstraints = false
        pushButton.configuration = .filled()
        pushButton.setTitle("Push", for: [])
        pushButton.addTarget(self, action: #selector(pushTapped), for: .primaryActionTriggered)
        
        presentButton.translatesAutoresizingMaskIntoConstraints = false
        presentButton.configuration = .filled()
        presentButton.setTitle("Present", for: [])
        presentButton.addTarget(self, action: #selector(presentTapped), for: .primaryActionTriggered)
    }
    
    func layout() {
        stackView.addArrangedSubview(pushButton)
        stackView.addArrangedSubview(presentButton)
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    @objc func pushTapped() {
        navigationController?.pushViewController(PushViewController(), animated: true)
    }
    
    @objc func presentTapped() {
        navigationController?.present(PresentViewController(), animated: true)
    }
}

class PushViewController: UIViewController {
    private let stackView = UIStackView()
    private let popButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        style()
        layout()
    }
}

private extension PushViewController {
    func style() {
        title = "Pushed ViewController"
        view.backgroundColor = .systemPurple
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 20
        
        popButton.translatesAutoresizingMaskIntoConstraints = false
        popButton.configuration = .filled()
        popButton.setTitle("Pop", for: [])
        popButton.addTarget(self, action: #selector(popTapped), for: .primaryActionTriggered)
    }
    
    func layout() {
        stackView.addArrangedSubview(popButton)
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    @objc func popTapped() {
        navigationController?.popViewController(animated: true)
    }
}

class PresentViewController: UIViewController {
    private let stackView = UIStackView()
    private let dismissButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        style()
        layout()
    }
}

private extension PresentViewController {
    func style() {
        title = "Not shown"
        view.backgroundColor = .systemPurple
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 20
        
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        dismissButton.configuration = .filled()
        dismissButton.setTitle("Dismiss", for: [])
        dismissButton.addTarget(self, action: #selector(dismissTapped), for: .primaryActionTriggered)
    }
    
    func layout() {
        stackView.addArrangedSubview(dismissButton)
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    @objc func dismissTapped() {
        dismiss(animated: true)
    }
}
