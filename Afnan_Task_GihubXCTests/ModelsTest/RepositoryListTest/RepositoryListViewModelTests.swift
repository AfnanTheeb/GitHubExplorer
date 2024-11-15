//
//  RepositoryListViewModelTests.swift
//  Afnan_Task_GihubXCTests
//
//  Created by Afnan Alotaibi on 14/05/1446 AH.
//

import XCTest
import Combine
@testable import Afnan_Task_Gihub

final class RepositoryListViewModelTests: XCTestCase {
    private var viewModel: RepositoryListViewModel!
    private var mockAPIService: MockAPIService!
    private var mockNetworkService: MockNetworkService!
    private var dependencies: Dependencies!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockAPIService = MockAPIService()
        mockNetworkService = MockNetworkService()
        dependencies = Dependencies(apiService: mockAPIService, networkService: mockNetworkService)
        cancellables = []
    }
    
    override func tearDown() {
        viewModel = nil
        mockAPIService = nil
        mockNetworkService = nil
        dependencies = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testInitialization() {
        // GIVEN dependencies and username
        let userName = "TestUser"
        
        // WHEN initializing the view model
        viewModel = RepositoryListViewModel(dependencies: dependencies, userName: userName)
        
        // THEN verify username and initial state
        XCTAssertEqual(viewModel.userName, userName)
        XCTAssertEqual(viewModel.state, .loading)
    }
    
    func testFetchRepositoriesSuccess() async throws {
        // GIVEN mock repositories
        let mockRepositories = [
            RepositoryModel(name: "Repo1", description: "Description1", license: License(name: "License1")),
            RepositoryModel(name: "Repo2", description: "Description2", license: License(name: "License2"))
        ]
        mockAPIService.setMockResponse(response: mockRepositories)
        
        // WHEN fetching repositories
        viewModel = RepositoryListViewModel(dependencies: dependencies, userName: "TestUser")
        await viewModel.fetchRepositories()
        
        // THEN verify success state and repositories
        XCTAssertEqual(viewModel.state, .success)
        XCTAssertEqual(viewModel.repositories.count, 2)
        XCTAssertEqual(viewModel.repositories[0].name, "Repo1")
    }
    
    func testFetchRepositoriesNoData() async throws {
        // GIVEN no repositories
        let mockRepositories: [RepositoryModel] = []
        mockAPIService.setMockResponse(response: mockRepositories)
        
        // WHEN fetching repositories
        viewModel = RepositoryListViewModel(dependencies: dependencies, userName: "TestUser")
        await viewModel.fetchRepositories()
        
        // THEN verify noData state
        XCTAssertEqual(viewModel.state, .noData)
        XCTAssertEqual(viewModel.repositories.count, 0)
    }
    
    func testFetchRepositoriesFailure() async {
        // GIVEN mock error
        let mockError = NSError(domain: "TestError", code: 500, userInfo: [NSLocalizedDescriptionKey: "Internal Server Error"])
        mockAPIService.setMockError(error: mockError)
        
        // WHEN fetching repositories
        viewModel = RepositoryListViewModel(dependencies: dependencies, userName: "TestUser")
        await viewModel.fetchRepositories()
        
        // THEN verify failure state
        if case .failure(let errorMessage) = viewModel.state {
            XCTAssertEqual(errorMessage, "Internal Server Error")
        } else {
            XCTFail("Expected failure state but got \(viewModel.state)")
        }
    }
    
    func testObserveNetworkStatus() {
        // GIVEN initial connected state
        viewModel = RepositoryListViewModel(dependencies: dependencies, userName: "TestUser")
        XCTAssertTrue(viewModel.isConnected)
        
        // WHEN connection changes
        mockNetworkService.isConnected = false
        
        // THEN verify connection state updates
        let expectation = XCTestExpectation(description: "Network status updated")
        viewModel.$isConnected
            .sink { isConnected in
                XCTAssertFalse(isConnected)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
}
