//
//  FlowCountroller.swift
//  GitHubExplorer
//
//  Created by Afnan Alotaibi on 07/05/1446 AH.
//

import Foundation
import UIKit

public class FlowController: UIViewController {
    
    internal let navigation = UINavigationController()
    private let dependencies: Dependencies

    public init(dependencies: Dependencies) {
        self.dependencies = dependencies
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        start()
    }
    
    internal func setup() {
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        navigation.navigationBar.titleTextAttributes = textAttributes
        navigation.navigationBar.tintColor = .black

    }

    internal func start() {
        let usersListViewController = UsersListViewController(
            viewModel: UsersListViewModel(dependencies: dependencies),
            onPressUser: showRepositoryList
        )
        navigation.viewControllers = [usersListViewController]
        addVC(child: navigation)
    }
    
    internal func showRepositoryList(username: String) {
        let viewModel = RepositoryListViewModel(
            dependencies: dependencies,
            userName: username
        )
        let repositoryListViewController = RepositoryListViewController(viewModel: viewModel, onPressRepo: showForkedUsers )
        navigation.pushViewController(repositoryListViewController, animated: true)
    }
    
    internal func showForkedUsers(userName: String, repoName: String) {
        let viewModel = ForkedUsersListViewModel(
            dependencies: dependencies,
            userName: userName,
            repositoryName: repoName
        )
        let forkedUsersListViewController = ForkedUsersListViewController(viewModel: viewModel)
        navigation.pushViewController(forkedUsersListViewController, animated: true)
    }
}
