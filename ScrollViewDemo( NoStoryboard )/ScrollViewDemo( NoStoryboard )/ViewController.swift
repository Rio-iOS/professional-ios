//
//  ViewController.swift
//  ScrollViewDemo( NoStoryboard )
//
//  Created by 藤門莉生 on 2024/06/16.
//

import UIKit

class ViewController: UIViewController {

    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        layout()
    }
}

private extension ViewController {
    func style() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 20
    }
    
    func layout() {
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        
        stackView.addArrangedSubview(makeCustomView())
        
        for _ in 0 ..< 20 {
            stackView.addArrangedSubview(makeLabel())
        }
        
        // ScrollView
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        
        // StackView within the ScrollView
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
        ])
       
        // stackViewのwidthの制約
        // NOTE: 制約が無い場合、画面幅にに表示されない
        stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
    }
    
    
    func makeLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Welcome"
        label.textAlignment = .center
        label.backgroundColor = .systemGray
        return label
    }
    
    func makeCustomView() -> UIView {
        let customView = CustomeView()
        customView.translatesAutoresizingMaskIntoConstraints = false
        return customView
    }
}

class CustomeView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemOrange
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 200)
    }
}
