//
//  AppFlowController.swift
//  Top 100
//
//  Created by Jack Bransfield on 7/9/20.
//  Copyright © 2020 Built Light. All rights reserved.
//

import UIKit

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
}

// MARK: - AlbumDetailViewControllerDelegate

extension AppFlowController: AlbumDetailViewControllerDelegate {
    
    func albumDetailViewController(_ viewController: AlbumDetailViewController, didRequestAppleMusic url: URL) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
