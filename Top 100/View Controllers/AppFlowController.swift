//
//  AppFlowController.swift
//  Top 100
//
//  Created by Jack Bransfield on 7/9/20.
//  Copyright © 2020 Built Light. All rights reserved.
//

import UIKit

/// The Flow Controller pattern is similar to the Coordinator pattern, but it takes advantage of existing
/// UIKit APIs and concepts, like view controller containment and the responder chain.
///
/// Similar to existing classes like `UINavigationController`, `UITabBarController`, and `UIPageViewController`,
/// a flow controller does not directly display content. Instead, its primary role is to manage a set of child
/// view controllers. Its responsibilities include:
/// - instantiating child view controllers
/// - injecting dependencies needed by those view controllers
/// - navigating between child view controllers, typically in response to delegate callbacks
///
/// As a result, conventional view controllers have a far more limited set of responsibilities, and can become
/// smaller and more reusable. Because the pattern relies on view controller containment, it doesn't require
/// maintaining a separate hierarchy of coordinator objects, and has a much shallower learning curve for
/// most iOS developers.
class AppFlowController: UIViewController {
    
    // MARK: - Properties
    
    private var childNavigationController: UINavigationController?
    
    // MARK: - UIViewController
    
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white
        self.view = view
        self.configureChildNavigationController()
    }
    
    // MARK: - Setup
    
    private func configureChildNavigationController() {
        let albumListVC = AlbumListViewController()
        albumListVC.delegate = self
        let childNav = UINavigationController(rootViewController: albumListVC)
        self.install(childViewController: childNav, addingConstraints: true)
        self.childNavigationController = childNav
    }
    
    // MARK: - Navigation
    
    private func showAlbumDetails(for album: Album) {
        let modelController = AlbumDetailModelController(album: album)
        let albumDetailVC = AlbumDetailViewController(modelController: modelController)
        albumDetailVC.delegate = self
        self.childNavigationController?.pushViewController(albumDetailVC, animated: true)
    }
}

// MARK: - AlbumListViewControllerDelegate

extension AppFlowController: AlbumListViewControllerDelegate {
    
    func albumListViewController(_ viewController: AlbumListViewController, didSelectAlbum album: Album) {
        self.showAlbumDetails(for: album)
    }
    
    func albumListViewController(_ viewController: AlbumListViewController, didReceiveError error: Error) {
        let alertController = UIAlertController.alertController(with: error)
        self.present(alertController, animated: true, completion: nil)
    }
}

// MARK: - AlbumDetailViewControllerDelegate

extension AppFlowController: AlbumDetailViewControllerDelegate {
    
    func albumDetailViewController(_ viewController: AlbumDetailViewController, didRequestAppleMusic url: URL) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
