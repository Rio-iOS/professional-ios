import UIKit

let appColor: UIColor = .systemTeal

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    let loginViewController = LoginViewController()
    let onboardingContainerViewController = OnboardingContainerViewController()
    let mainViewController = MainViewController()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        window.backgroundColor = .systemBackground
        self.window = window
        self.window?.makeKeyAndVisible()

        loginViewController.delegate = self
        onboardingContainerViewController.delegate = self
        
        registerForNotifications()
      
        displayLogin()
        
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

extension SceneDelegate: LoginViewControllerDelegate {
    func didLogIn() {
        displayNextScreen()
    }
}

extension SceneDelegate: OnboardingContainerViewControllerDelegate {
    func didFinishOnboarding() {
        LocalState.hasOnboarded = true
        prepMainView()
        setRootViewController(mainViewController)
    }
}

extension SceneDelegate: LogoutDelegate {
    @objc func didLogout() {
        setRootViewController(loginViewController)
    }
}

private extension SceneDelegate {
    func registerForNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(didLogout), name: .logout, object: nil)
    }
    
    func setRootViewController(_ viewController: UIViewController, animated: Bool = true) {
        guard animated, let window else {
            window?.rootViewController = viewController
            window?.makeKeyAndVisible()
            return
        }
        
        window.rootViewController = viewController
        window.makeKeyAndVisible()
        UIView.transition(
            with: window,
            duration: 0.7,
            options: .transitionCrossDissolve,
            animations: nil,
            completion: nil
        )
    }
    
    func displayLogin() {
        setRootViewController(loginViewController)
    }
    
    func prepMainView() {
        mainViewController.setStatusBar()
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().backgroundColor = appColor
    }
    
    func displayNextScreen() {
        if LocalState.hasOnboarded {
            prepMainView()
            setRootViewController(mainViewController)
        } else {
            setRootViewController(onboardingContainerViewController)
        }
    }
}
