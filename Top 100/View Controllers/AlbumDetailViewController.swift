//
//  AlbumDetailViewController.swift
//  Top 100
//
//  Created by Jack Bransfield on 7/12/20.
//  Copyright © 2020 Built Light. All rights reserved.
//

import UIKit

protocol AlbumDetailViewControllerDelegate: class {
    func albumDetailViewController(_ viewController: AlbumDetailViewController, didRequestAppleMusic url: URL)
}

class AlbumDetailViewController: UIViewController {
    
    // MARK: - Properties

    let modelController: AlbumDetailModelController
    weak var delegate: AlbumDetailViewControllerDelegate?
    
    // MARK: - Views
    
    var stackView: UIStackView?
    
    let artworkView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 200),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
        ])
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .darkText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let artistLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        label.textColor = .darkText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let genreLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let dateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let copyrightLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let appleMusicButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("View in Apple Music", for: .normal)
        button.backgroundColor = .tertiarySystemFill
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(launchAppleMusic), for: .touchUpInside)
        return button
    }()

    // MARK: - Initialization
  
    init(modelController: AlbumDetailModelController) {
        self.modelController = modelController
        super.init(nibName: nil, bundle: nil)
        self.modelController.delegate = self
    }
    
    /// The view controller cannot be initialized without a model controller,
    /// so this initializer will always return `nil`.
    required init?(coder: NSCoder) {
        return nil
    }
    
    // MARK: - UIViewController
    
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white
        self.view = view
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureAppleMusicButton()
        self.configureStackView()
        self.layoutStackView()
        self.populateContentViews()
    }
    
    func populateContentViews() {
        self.title = self.modelController.albumRank
        self.nameLabel.text = self.modelController.albumName
        self.artistLabel.text = self.modelController.artistName
        self.genreLabel.text = self.modelController.genres
        self.dateLabel.text = self.modelController.releaseDate
        self.copyrightLabel.text = self.modelController.copyrightInfo
        self.artworkView.image = self.modelController.artwork
    }
        
    // MARK: - Setup
    
    private func configureStackView() {
        let stackView = UIStackView(arrangedSubviews: [
            self.artworkView,
            self.nameLabel,
            self.artistLabel,
            self.genreLabel,
            self.dateLabel,
            self.copyrightLabel
        ])
        self.view.addSubview(stackView)
        stackView.spacing = 3
        stackView.axis = .vertical
        stackView.alignment = .leading
        self.stackView = stackView
    }
    
    private func layoutStackView() {
        guard let stackView = self.stackView else { return }
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 4),
            stackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20)
        ])
        
        stackView.setCustomSpacing(20, after: self.artworkView)
        stackView.setCustomSpacing(6, after: self.dateLabel)
    }
        
    private func configureAppleMusicButton() {
        self.view.addSubview(self.appleMusicButton)
        let padding: CGFloat = 20
        NSLayoutConstraint.activate([
            self.appleMusicButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: padding),
            self.appleMusicButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: padding * -1),
            self.appleMusicButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: padding * -1),
            self.appleMusicButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    // MARK: - Actions

    @objc func launchAppleMusic() {
        self.delegate?.albumDetailViewController(self, didRequestAppleMusic: self.modelController.appleMusicUrl)
    }
}

// MARK: - AlbumDetailModelControllerDelegate

extension AlbumDetailViewController: AlbumDetailModelControllerDelegate {
    
    func albumDetailModelController(_ controller: AlbumDetailModelController, didReceiveImage image: UIImage) {
        self.artworkView.image = image
    }
}
