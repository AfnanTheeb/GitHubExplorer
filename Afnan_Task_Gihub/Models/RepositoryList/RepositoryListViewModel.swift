//
//  RepositoryListViewModel.swift
//  GitHubExplorer
//
//  Created by Afnan Alotaibi on 07/05/1446 AH.
//

import Foundation
import Combine

enum StateRepo: Equatable {
    case loading
    case noData
    case success
    case failure(String)
}

class RepositoryListViewModel {
    // Published variable to update the view
    private let dependencies: Dependencies
    private var cancellables = Set<AnyCancellable>()
    var repositories: [RepositoryModel] = []
    let userName: String
    
    @Published var state: StateRepo = .loading
    @Published var isConnected: Bool = true
    
    
    init(dependencies: Dependencies, userName: String) {
        self.dependencies = dependencies
        self.userName = userName
        observeNetworkStatus(networkService: dependencies.networkService)
        
        Task {
            await self.fetchRepositories()
        }
    }
    
    @MainActor
    func fetchRepositories() async {
        do {
            let repos = try await dependencies.apiService.fetchData(path: "/users/\(userName)/repos", model: [RepositoryModel].self)
            repositories = repos
            state = repos.isEmpty ? .noData : .success
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

