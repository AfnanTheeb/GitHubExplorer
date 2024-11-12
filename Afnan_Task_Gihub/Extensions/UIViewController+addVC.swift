//
//  UIViewController+addVC.swift
//  GitHubExplorer
//
//  Created by Afnan Alotaibi on 06/05/1446 AH.
//

import UIKit

public extension UIViewController {
    
    func addVC(child childViewController: UIViewController, toView containerView: UIView? = nil, inset: UIEdgeInsets = .zero) {
        var containerView = containerView
        if containerView == nil {
            containerView = view
        }
        self.addChild(childViewController)
        containerView?.addSubview(childViewController.view)
        childViewController.didMove(toParent: self)
        childViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            childViewController.view.topAnchor.constraint(equalTo: containerView!.topAnchor, constant: inset.top),
            childViewController.view.bottomAnchor.constraint(equalTo: containerView!.bottomAnchor, constant: -inset.bottom),
            childViewController.view.leadingAnchor.constraint(equalTo: containerView!.leadingAnchor, constant: inset.left),
            childViewController.view.trailingAnchor.constraint(equalTo: containerView!.trailingAnchor, constant: -inset.right)
        ])
    }
    
    func remove() {
        guard parent != nil else {
            return
        }
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}
