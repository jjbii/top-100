//
//  UIViewController+Additions.swift
//  Top 100
//
//  Created by Jack Bransfield on 7/9/20.
//  Copyright © 2020 Built Light. All rights reserved.
//

import UIKit

// Convenience methods for adding and removing child view controllers
extension UIViewController {
    
    func install(childViewController child: UIViewController, addingConstraints: Bool) {
        self.addChild(child)
        self.view.addSubview(child.view)
        if addingConstraints {
            child.view.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                child.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                child.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                child.view.topAnchor.constraint(equalTo: self.view.topAnchor),
                child.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
            ])
        }
        child.didMove(toParent: self)
    }
    
    func uninstall() {
        guard let _ = self.parent else {
            return
        }
        
        self.willMove(toParent: nil)
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
}
