//
//  AlbumListViewController.swift
//  Top 100
//
//  Created by Jack Bransfield on 7/9/20.
//  Copyright © 2020 Built Light. All rights reserved.
//

import UIKit

protocol AlbumListViewControllerDelegate: class {
    func albumListViewController(_ viewController: AlbumListViewController, didSelectAlbumAtIndex index: Int)
}

class AlbumListViewController: UIViewController {
    
    // MARK: - Properties

    weak var delegate: AlbumListViewControllerDelegate?

    // MARK: - UIViewController
    
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .green
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Top Albums"
    }
}
