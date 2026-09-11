import UIKit

final class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }


}

final class SearchViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search"
        view.backgroundColor = .systemRed
    }
}

final class ContactsViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Contacts"
        view.backgroundColor = .systemGreen
    }
}

final class FavoritesViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Favorites"
        view.backgroundColor = .systemBlue
    }
}
