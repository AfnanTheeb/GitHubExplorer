import UIKit
import Combine

class RepositoryListViewController: UIViewController {
    
    private let tableView = UITableView()
    private var cancellables = Set<AnyCancellable>()
    private let viewModel: RepositoryListViewModel
    private let onPressRepo: (String, String) -> Void
    private let networkAlertView = NetworkConnectionAlertView()
    
    init(
        viewModel: RepositoryListViewModel,
        onPressRepo: @escaping (String, String) -> Void
    ) {
        self.viewModel = viewModel
        self.onPressRepo = onPressRepo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView()
        activity.translatesAutoresizingMaskIntoConstraints = false
        activity.hidesWhenStopped = true
        activity.color = .gray
        activity.style = .large
        return activity
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTable()
        layout()
        bindViewModel()
    }
    
    private func setupTable() {
        title = "\(viewModel.userName) Repositories"
        view.backgroundColor = .white
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(RepositoryCell.self, forCellReuseIdentifier: "RepositoryCell")
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
    
    private func bindViewModel() {
        viewModel.$state
            .receive(on: RunLoop.main)
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
    
    private func startLoading() {
        activityIndicator.startAnimating()
    }
    
    private func stopLoading() {
        activityIndicator.stopAnimating()
    }
    
    private func showNoDataView() {
        let noDataLabel = UILabel()
        noDataLabel.text = "No Repositories Available"
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

extension RepositoryListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.repositories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RepositoryCell", for: indexPath) as? RepositoryCell else {
            return UITableViewCell()
        }
        
        let repository = viewModel.repositories[indexPath.row]
        cell.configure(with: repository)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedRepository = viewModel.repositories[indexPath.row]
        onPressRepo(viewModel.userName, selectedRepository.name)
    }
}
