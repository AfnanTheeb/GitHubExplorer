//
//  ForkedUsersListViewModelTests.swift
//  Afnan_Task_GihubXCTests
//
//  Created by Afnan Alotaibi on 14/05/1446 AH.
//

import XCTest
import Combine
@testable import Afnan_Task_Gihub

final class ForkedUsersListViewModelTests: XCTestCase {
    private var viewModel: ForkedUsersListViewModel!
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
        // GIVEN dependencies, username, and repository name
        let userName = "TestUser"
        let repositoryName = "TestRepo"
        
        // WHEN initializing the view model
        viewModel = ForkedUsersListViewModel(dependencies: dependencies, userName: userName, repositoryName: repositoryName)
        
        // THEN verify initial state and properties
        XCTAssertEqual(viewModel.userName, userName)
        XCTAssertEqual(viewModel.repositoryName, repositoryName)
        XCTAssertEqual(viewModel.state, .loading)
    }
    
    func testFetchForkUsersSuccess() async throws {
        // GIVEN mock forked users
        let mockForkedUsers = [
            ForkedUserModel(id: 1, login: "User1", avatarUrl: "https://example.com/avatar1.png"),
            ForkedUserModel(id: 2, login: "User2", avatarUrl: "https://example.com/avatar2.png")
        ]
        mockAPIService.setMockResponse(response: mockForkedUsers)
        
        // WHEN fetching forked users
        viewModel = ForkedUsersListViewModel(dependencies: dependencies, userName: "TestUser", repositoryName: "TestRepo")
        await viewModel.fetchForkUsers()
        
        // THEN verify success state and forked users
        XCTAssertEqual(viewModel.state, .success)
        XCTAssertEqual(viewModel.users.count, 2)
        XCTAssertEqual(viewModel.users[0].username, "User1")
        XCTAssertEqual(viewModel.users[0].imageURL, "https://example.com/avatar1.png")
    }
    
    func testFetchForkUsersNoData() async throws {
        // GIVEN no forked users
        let mockForkedUsers: [ForkedUserModel] = []
        mockAPIService.setMockResponse(response: mockForkedUsers)
        
        // WHEN fetching forked users
        viewModel = ForkedUsersListViewModel(dependencies: dependencies, userName: "TestUser", repositoryName: "TestRepo")
        await viewModel.fetchForkUsers()
        
        // THEN verify noData state
        XCTAssertEqual(viewModel.state, .noData)
        XCTAssertEqual(viewModel.users.count, 0)
    }
    
    func testFetchForkUsersFailure() async {
        // GIVEN mock error
        let mockError = NSError(domain: "TestError", code: 500, userInfo: [NSLocalizedDescriptionKey: "Internal Server Error"])
        mockAPIService.setMockError(error: mockError)
        
        // WHEN fetching forked users
        viewModel = ForkedUsersListViewModel(dependencies: dependencies, userName: "TestUser", repositoryName: "TestRepo")
        await viewModel.fetchForkUsers()
        
        // THEN verify failure state
        if case .failure(let errorMessage) = viewModel.state {
            XCTAssertEqual(errorMessage, "Data could not be read: Internal Server Error")
        } else {
            XCTFail("Expected failure state but got \(viewModel.state)")
        }
    }
    
    func testObserveNetworkStatus() {
        // GIVEN initial connected state
        viewModel = ForkedUsersListViewModel(dependencies: dependencies, userName: "TestUser", repositoryName: "TestRepo")
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
