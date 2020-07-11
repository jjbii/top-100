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
    var tableView: UITableView?
    var modelController: AlbumListModelController?

    // MARK: - UIViewController
    
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureTableView()
        self.modelController = AlbumListModelController(delegate: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.clearCurrentSelection()
    }
    
    // MARK: - Setup
    
    func configureTableView() {
        let tableView = UITableView(frame: self.view.bounds)
        self.view.addSubview(tableView)
        tableView.rowHeight = 64.0
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        tableView.dataSource = self
        tableView.delegate = self
        self.tableView = tableView
    }
        
    func clearCurrentSelection() {
        guard let indexPath = self.tableView?.indexPathForSelectedRow else {
            return
        }
        self.tableView?.deselectRow(at: indexPath, animated: false)
    }
}

// MARK: - UITableViewDataSource

extension AlbumListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.modelController?.numberOfAlbums() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "AlbumCell")
        
        let album = self.modelController?.album(at: indexPath.row)
        
        cell.textLabel?.text = album?.name ?? "Album name"
        cell.detailTextLabel?.text = album?.artistName ?? "Artist name"
        if let imageView = cell.imageView {
            imageView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                imageView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 16.0),
                imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),
                imageView.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
                imageView.heightAnchor.constraint(equalTo: cell.contentView.heightAnchor, constant: -8.0)
            ])
            let cover = UIImage(named: "200x200bb")
            imageView.image =  cover
        }
        return cell
    }
}

// MARK: - UITableViewDelegate

extension AlbumListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let album = self.modelController?.album(at: indexPath.row) else { return }
        self.delegate?.albumListViewController(self, didSelectAlbum: album)
    }
}

// MARK: - AlbumListModelControllerDelegate

extension AlbumListViewController: AlbumListModelControllerDelegate {
    
    func albumListModelControllerDidUpdate(_ controller: AlbumListModelController) {
        self.title = controller.listTitle
        self.tableView?.reloadData()
    }
    
    func albumListModelController(_ controller: AlbumListModelController, didReceiveError error: Error) {
        // TODO: Show an alert with the error.
        print("AlbumListModelController did receive error.")
    }
}
