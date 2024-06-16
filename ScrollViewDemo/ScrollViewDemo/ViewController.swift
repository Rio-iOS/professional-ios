//
//  ViewController.swift
//  ScrollViewDemo
//
//  Created by 藤門莉生 on 2024/06/16.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var stackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        for i in 0 ..< 30 {
            let label = UILabel()
            label.text = "Label \(i)"
            stackView.addArrangedSubview(label)
        }
    }


}

