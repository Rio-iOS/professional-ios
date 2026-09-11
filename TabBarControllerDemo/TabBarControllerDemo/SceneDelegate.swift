import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        window.makeKeyAndVisible()
        window.backgroundColor = .systemBackground
        
        let searchViewController = UINavigationController(rootViewController: SearchViewController())
        searchViewController.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        let contactsViewController = UINavigationController(rootViewController: ContactsViewController())
        contactsViewController.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        let favoritesViewController = UINavigationController(rootViewController: FavoritesViewController())
        favoritesViewController.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]

        searchViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        contactsViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .contacts, tag: 1)
        favoritesViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 2)
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [
            searchViewController,
            contactsViewController,
            favoritesViewController
        ]
        
        window.rootViewController = tabBarController
        self.window = window
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
    }


}

