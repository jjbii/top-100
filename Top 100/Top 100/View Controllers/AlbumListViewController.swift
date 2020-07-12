//
//  AlbumListViewController.swift
//  Top 100
//
//  Created by Jack Bransfield on 7/9/20.
//  Copyright © 2020 Built Light. All rights reserved.
//

import UIKit

protocol AlbumListViewControllerDelegate: class {
    func albumListViewController(_ viewController: AlbumListViewController, didSelectAlbum album: Album)
}

class AlbumListViewController: UIViewController {
      
    // MARK: - Properties

    weak var delegate: AlbumListViewControllerDelegate?
    var tableView = UITableView()
    var modelController = AlbumListModelController()

    // MARK: - UIViewController
    
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureTableView()
        self.configureModelController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.clearCurrentSelection()
    }
    
    // MARK: - Setup
    
    func configureTableView() {
        self.view.addSubview(self.tableView)
        self.tableView.constrain(to: self.view)
        self.tableView.rowHeight = 64.0
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(AlbumCell.self, forCellReuseIdentifier: AlbumCell.identifier)
    }
    
    func configureModelController() {
        self.modelController.delegate = self
        self.modelController.getAlbumFeed()
    }
        
    func clearCurrentSelection() {
        guard let indexPath = self.tableView.indexPathForSelectedRow else {
            return
        }
        self.tableView.deselectRow(at: indexPath, animated: false)
    }
    
    private func visibleCell(for index: Int) -> AlbumCell? {
        let indexPath = IndexPath(row: index, section: 0)
        guard
            let visibleIndexPaths = self.tableView.indexPathsForVisibleRows,
            visibleIndexPaths.contains(indexPath) else {
                return nil
        }
        return self.tableView.cellForRow(at: indexPath) as? AlbumCell
    }
}

// MARK: - UITableViewDataSource

extension AlbumListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.modelController.numberOfAlbums()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AlbumCell.identifier, for: indexPath) as? AlbumCell else {
            return UITableViewCell()
        }
        
        cell.nameLabel.text = self.modelController.albumName(for: indexPath.row)
        cell.artistLabel.text = self.modelController.artistName(for: indexPath.row)
        cell.rankLabel.text = String(indexPath.row + 1)
        cell.artworkView.image = self.modelController.artwork(for: indexPath.row)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension AlbumListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let album = self.modelController.album(at: indexPath.row) else { return }
        self.delegate?.albumListViewController(self, didSelectAlbum: album)
    }
}

// MARK: - AlbumListModelControllerDelegate

extension AlbumListViewController: AlbumListModelControllerDelegate {
    
    func albumListModelControllerDidUpdate(_ controller: AlbumListModelController) {
        self.title = controller.listTitle
        self.tableView.reloadData()
    }
    
    func albumListModelController(_ controller: AlbumListModelController, didReceiveError error: Error) {
        // TODO: Show an alert with the error.
        print("AlbumListModelController did receive error.\n\(error)")
    }
    
    func albumListModelController(_ controller: AlbumListModelController, didReceiveImage image: UIImage, forAlbumAt index: Int) {
        self.visibleCell(for: index)?.artworkView.image = image
    }
}

// TODO: Add prefetching support.
