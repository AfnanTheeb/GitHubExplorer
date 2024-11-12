//
//  UsersListViewController.swift
//  GitHubExplorer
//
//  Created by Afnan Alotaibi on 06/05/1446 AH.
//

import UIKit
import SwiftUI

class UsersListViewController: UIViewController {
    
    let viewModel: UsersListViewModel
    let onPressUser: (String) -> Void

    init(viewModel: UsersListViewModel,
         onPressUser: @escaping (String) -> Void
    ) {
        self.viewModel = viewModel
        self.onPressUser = onPressUser
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "GitHub Users"
        let hostingViewController = UIHostingController(
            rootView: UserListView(
                viewModel: viewModel,
                onPressUser: onPressUser
            )
        )
        addVC(child: hostingViewController)
    }    
}
