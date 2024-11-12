//
//  ForkedUserTableViewCell.swift
//  GitHubExplorer
//
//  Created by Afnan Alotaibi on 08/05/1446 AH.
//

import UIKit
import SwiftUI

class ForkedUserTableViewCell: UITableViewCell {
    
    // MARK:  Properties
    static let identifier = "ForkedUserTableViewCell"
    private var hostingController: UIHostingController<UserRowView>?
    
    // MARK:  Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupHostingController()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:  Setup Methods
    private func setupHostingController() {
        hostingController = UIHostingController(rootView: UserRowView(name: "", image: ""))
        
        if let hostingController = hostingController {
            contentView.addSubview(hostingController.view)
            hostingController.view.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                hostingController.view.topAnchor.constraint(equalTo: contentView.topAnchor),
                hostingController.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                hostingController.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                hostingController.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            ])
        }
    }
    
    // MARK:  Configuration
    func configure(with username: String, imageURL: String) {
        hostingController?.rootView = UserRowView(name: username, image: imageURL)
    }
}
