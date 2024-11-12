//
//  Dependencies.swift
//  GitHubExplorer
//
//  Created by Afnan Alotaibi on 09/05/1446 AH.
//

public class Dependencies {
    
    public let apiService: APIService
    public let networkService: NetworkService
    
    init(apiService: APIService, networkService: NetworkService) {
        self.apiService = apiService
        self.networkService = networkService
    }
    
    deinit {
        print("SceneDelegate has been deallocated")
    }
}
