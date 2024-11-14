//
//  FlowControllerTests.swift
//  Afnan_Task_Gihub
//
//  Created by Afnan Alotaibi on 12/05/1446 AH.
//

import XCTest
@testable import Afnan_Task_Gihub

class FlowControllerTests: XCTestCase {
    
    var flowController: FlowController!
    var mockAPIService: MockAPIService!
    var mockNetworkService: MockNetworkService!
    var mockDependencies: Dependencies!
    
    override func setUpWithError() throws {
        mockAPIService = MockAPIService()
        mockNetworkService = MockNetworkService()
        mockDependencies = Dependencies(apiService: mockAPIService, networkService: mockNetworkService)
        
        flowController = FlowController(dependencies: mockDependencies)
    }
    
    override func tearDownWithError() throws {
        flowController = nil
        mockAPIService = nil
        mockNetworkService = nil
        mockDependencies = nil
    }
    
    func testFlowControllerInitialization() throws {
        XCTAssertNotNil(flowController, "FlowController should be initialized successfully.")
    }
    
    func testStartFlow() throws {
        // When
        flowController.start()
        
        // Then
        let navigationController = flowController.navigation
        XCTAssertNotNil(navigationController)
        XCTAssertTrue(navigationController.viewControllers.first is UsersListViewController)
    }
    
    func testShowRepositoryList() throws {
        // When
        flowController.showRepositoryList(username: "testuser")
        
        // Then
        let navigationController = flowController.navigation.viewControllers.last
        XCTAssertTrue(navigationController is RepositoryListViewController)
    }
    
    func testShowForkedUsers() throws {
        // When
        flowController.showForkedUsers(userName: "testuser", repoName: "testrepo")
        
        // Then
        let navigationController = flowController.navigation.viewControllers.last
        XCTAssertTrue(navigationController is ForkedUsersListViewController)
    }
}
