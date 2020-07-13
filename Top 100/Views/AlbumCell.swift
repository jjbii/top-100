//
//  AlbumCell.swift
//  Top 100
//
//  Created by Jack Bransfield on 7/11/20.
//  Copyright © 2020 Built Light. All rights reserved.
//

import UIKit

class AlbumCell: UITableViewCell {

    static let identifier = "AlbumCell"
    
    // MARK: - Properties
    
    let artworkView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        imageView.layer.cornerRadius = 4
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let rankLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .darkText
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .darkText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let artistLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configureArtworkView()
        self.configureRankLabel()
        self.configureNameLabel()
        self.configureArtistLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    func configureArtworkView() {
        self.contentView.addSubview(self.artworkView)
        let padding: CGFloat = 8
        NSLayoutConstraint.activate([
            self.artworkView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: padding),
            self.artworkView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: padding),
            self.artworkView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: (padding * -1)),
            self.artworkView.widthAnchor.constraint(equalTo: self.artworkView.heightAnchor)
        ])
    }
    
    func configureRankLabel() {
        self.contentView.addSubview(self.rankLabel)
        NSLayoutConstraint.activate([
            self.rankLabel.leadingAnchor.constraint(equalTo: self.artworkView.trailingAnchor, constant: 8),
            self.rankLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            self.rankLabel.widthAnchor.constraint(equalToConstant: 32)
        ])
    }
    
    func configureNameLabel() {
        self.contentView.addSubview(self.nameLabel)
        NSLayoutConstraint.activate([
            self.nameLabel.leadingAnchor.constraint(equalTo: self.rankLabel.trailingAnchor, constant: 8),
            self.nameLabel.lastBaselineAnchor.constraint(equalTo: self.contentView.centerYAnchor, constant: -3),
            self.nameLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -8)
        ])
    }
    
    func configureArtistLabel() {
        self.contentView.addSubview(self.artistLabel)
        NSLayoutConstraint.activate([
            self.artistLabel.leadingAnchor.constraint(equalTo: self.nameLabel.leadingAnchor),
            self.artistLabel.topAnchor.constraint(equalTo: self.contentView.centerYAnchor, constant: 3),
            self.artistLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -8)
        ])
    }
}
