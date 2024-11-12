//
//  ForkedUsersListViewController.swift
//  GitHubExplorer
//
//  Created by Afnan Alotaibi on 08/05/1446 AH.
//

import UIKit
import Combine

class ForkedUsersListViewController: UIViewController {

    // MARK:  Properties
    private var viewModel: ForkedUsersListViewModel
    private var cancellables: Set<AnyCancellable> = []
    private let networkAlertView = NetworkConnectionAlertView()

    
    // MARK:  UI Components
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ForkedUserTableViewCell.self, forCellReuseIdentifier: "UserCell")
        return tableView
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView()
        activity.translatesAutoresizingMaskIntoConstraints = false
        activity.hidesWhenStopped = true
        activity.color = .gray
        activity.style = .large
        return activity
    }()
    
    // MARK:  Initialization
    init(viewModel: ForkedUsersListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:  Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        layout()
        bind()
    }
    
    // MARK:  Setup Methods
    private func setupTableView() {
        title = "Forked Users"
        view.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func layout() {
        view.addSubview(networkAlertView)
        networkAlertView.translatesAutoresizingMaskIntoConstraints = false
        networkAlertView.isHidden = true
        
        NSLayoutConstraint.activate([
            networkAlertView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            networkAlertView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            networkAlertView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            networkAlertView.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: -20)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: networkAlertView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        view.addSubview(activityIndicator)
        view.addConstraints([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    // MARK:  Bind ViewModel
    private func bind() {
        // Bind the users data and handle states
        viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                guard let self = self else { return }
                switch state {
                case .loading:
                    self.startLoading()
                case .success:
                    self.stopLoading()
                    self.tableView.reloadData()
                case .failure(let error):
                    self.stopLoading()
                    self.showAlert(title: "Error", message: error)
                case .noData:
                    self.stopLoading()
                    self.showNoDataView()
                }
            }
            .store(in: &cancellables)
        
        viewModel.$isConnected
            .receive(on: RunLoop.main)
            .sink { [weak self] isConnected in
                guard let self = self else { return }
                self.networkAlertView.isHidden = isConnected
            }
            .store(in: &cancellables)
    }
    
    // MARK:  Loading & Error Handling
    private func startLoading() {
        activityIndicator.startAnimating()
    }
    
    private func stopLoading() {
        activityIndicator.stopAnimating()
    }
    
    private func showNoDataView() {
        let noDataLabel = UILabel()
        noDataLabel.text = "No Forked Users"
        noDataLabel.textAlignment = .center
        noDataLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(noDataLabel)
        
        NSLayoutConstraint.activate([
            noDataLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noDataLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func showAlert(title: String?, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate

extension ForkedUsersListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! ForkedUserTableViewCell
        let user = viewModel.users[indexPath.row]
        cell.configure(with: user.username, imageURL: user.imageURL)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70 
    }
}
