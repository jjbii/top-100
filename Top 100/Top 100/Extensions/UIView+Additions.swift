//
//  UIView+Additions.swift
//  Top 100
//
//  Created by Jack Bransfield on 7/11/20.
//  Copyright © 2020 Built Light. All rights reserved.
//

import UIKit

extension UIView {
    
    func constrain(to superView: UIView, withInsets insets: UIEdgeInsets = .zero) {
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.leadingAnchor.constraint(equalTo: superView.leadingAnchor,constant: insets.left),
            self.trailingAnchor.constraint(equalTo: superView.trailingAnchor, constant: insets.right),
            self.topAnchor.constraint(equalTo: superView.topAnchor, constant: insets.top),
            self.bottomAnchor.constraint(equalTo: superView.bottomAnchor, constant: insets.bottom)
        ])
    }
}
