//
//  MainViewController.swift
//  Bankey
//
//  Created by 藤門莉生 on 2024/06/16.
//

import Foundation
import UIKit

class MainViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupTabBar()
    }
}

private extension MainViewController {
    func setupViews() {
        let summaryVC = AccountSummaryViewController()
        let moneyVC = MoveMoneyViewController()
        let moreVC = MoreViewController()
        
        summaryVC.setTabBarImage(imageName: "list.dash.header.rectangle", title: "Summary")
        moneyVC.setTabBarImage(imageName: "arrow.left.arrow.right", title: "Move Money")
        moreVC.setTabBarImage(imageName: "ellipsis.circle", title: "More")
        
        let summaryNavigationController = UINavigationController(rootViewController: summaryVC)
        let moneyNavigationController = UINavigationController(rootViewController: moneyVC)
        let moreNavigationController = UINavigationController(rootViewController: moreVC)
        
        summaryNavigationController.navigationBar.barTintColor = appColor
        hideNavigationBarLine(summaryNavigationController.navigationBar)
        
        let tabBarList = [summaryNavigationController, moneyNavigationController, moreNavigationController]
        viewControllers = tabBarList
        
    }
    
    func setupTabBar() {
        tabBar.tintColor = appColor
        tabBar.isTranslucent = false
    }
    
    func hideNavigationBarLine(_ navigationBar: UINavigationBar) {
        let image = UIImage()
        navigationBar.shadowImage = image
        navigationBar.setBackgroundImage(image, for: .default)
        navigationBar.isTranslucent = false
    }
}

class AccountSummaryViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGreen
    }
}

class MoveMoneyViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemOrange
    }
}

class MoreViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemPurple
    }
}
