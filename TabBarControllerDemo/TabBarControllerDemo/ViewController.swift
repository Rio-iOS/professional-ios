//
//  ViewController.swift
//  TabBarControllerDemo
//
//  Created by 藤門莉生 on 2024/06/15.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

class SearchViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search"
        view.backgroundColor = .systemRed
    }
}

class ContactsViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Contacts"
        view.backgroundColor = .systemGreen
    }
}

class FavoritesViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Favorites"
        view.backgroundColor = .systemBlue
    }
}
