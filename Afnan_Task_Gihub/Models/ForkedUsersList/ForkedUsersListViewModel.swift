//
//  ForkedUsersListViewModel.swift
//  GitHubExplorer
//
//  Created by Afnan Alotaibi on 08/05/1446 AH.
//

import Foundation
import Combine

enum StateForked {
    case loading
    case noData
    case success
    case failure(String)
}

class ForkedUsersListViewModel: ObservableObject {
    // Published variables to update the view
    @Published var isConnected: Bool = true
    @Published var state: StateForked = .loading
    
    private var cancellables: Set<AnyCancellable> = []
    var users: [(username: String, imageURL: String)] = []
    private let dependencies: Dependencies
    let userName: String
    let repositoryName: String
    
    init(dependencies: Dependencies, userName: String, repositoryName: String) {
        self.dependencies = dependencies
        self.userName = userName
        self.repositoryName = repositoryName
        observeNetworkStatus(networkService: dependencies.networkService)
        
        Task {
            await fetchForkUsers()
        }
    }
    
    @MainActor
    func fetchForkUsers() async {
        guard let request = dependencies.apiService.makeRequest(path: "/repos/\(userName)/\(repositoryName)/forks") else {
            return state = .failure("Invaild request")
        }
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let forkedUsers = try JSONDecoder().decode([ForkedUserModel].self, from: data)
            
            if forkedUsers.isEmpty {
                state = .noData
            } else {
                users = forkedUsers.map { (username: $0.login, imageURL: $0.avatarUrl ?? "") }
                state = .success
            }
        } catch {
            state = .failure(error.localizedDescription)
        }
    }
    // network
    private func observeNetworkStatus(networkService: NetworkService) {
        networkService.$isConnected
            .sink { [weak self] isConnected in
                self?.isConnected = isConnected
            }
            .store(in: &cancellables)
    }
}

