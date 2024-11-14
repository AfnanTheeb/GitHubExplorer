//
//  UsersListViewModel.swift
//  GitHubExplorer
//
//  Created by Afnan Alotaibi on 06/05/1446 AH.
//

import Foundation
import Combine

enum State: Equatable {
    case loading
    case noData
    case success([UserModel])
    case failure(String)
}

class UsersListViewModel: ObservableObject {
    
    @Published var isConnected: Bool = true
    @Published var state: State = .loading
    private var cancellables: Set<AnyCancellable> = []
    
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
        Task {
            await fetchUsers()
        }
        observeNetworkStatus(networkService: dependencies.networkService)
    }
    
    @MainActor
    func fetchUsers() async {
        do {
            var users = try await dependencies.apiService.fetchData(path: "/users", model: [UserModel].self)
            
            // update data all user by fetchUserDetails
            users = try await withThrowingTaskGroup(of: UserModel.self) { group in
                for user in users {
                    group.addTask {
                        var userDetails = user
                        let detailedUser = try await self.fetchUserDetails(for: user.login)
                        userDetails.publicRepos = detailedUser.publicRepos
                        userDetails.followers = detailedUser.followers
                        return userDetails
                    }
                }
                return try await group.reduce(into: []) { $0.append($1) }
            }
            
            state = users.isEmpty ? .noData : .success(users)
        } catch {
            state = .failure("Data could not be read: \(error.localizedDescription)")
        }
    }

    func fetchUserDetails(for username: String) async throws -> UserModel {
        return try await dependencies.apiService.fetchData(
            path: "/users/\(username)",
            model: UserModel.self
        )
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


