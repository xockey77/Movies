import UIKit

class ApplicationCoordinator: Coordinator {
    let window: UIWindow
    let rootViewController: UINavigationController
    let moviesCoordinator: MoviesCoordinator

    init(window: UIWindow) {
        self.window = window
        rootViewController = UINavigationController()
        rootViewController.navigationBar.prefersLargeTitles = false
        moviesCoordinator = MoviesCoordinator(presenter: rootViewController)

    }
  
    func start() {
        window.rootViewController = rootViewController
        moviesCoordinator.start()
        window.makeKeyAndVisible()
    }
}
