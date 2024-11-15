//
//  Mocks.swift
//  Afnan_Task_Gihub
//
//  Created by Afnan Alotaibi on 12/05/1446 AH.
//

import XCTest
@testable import Afnan_Task_Gihub

public class MockAPIService: APIService {
    var mockData: Data?
    var mockError: Error?

    public func setMockResponse<T: Encodable>(response: T) {
        // تحويل النموذج إلى بيانات JSON
        do {
            self.mockData = try JSONEncoder().encode(response)
        } catch {
            print("Error encoding mock response: \(error)")
        }
    }

    public func setMockError(error: Error) {
        self.mockError = error
    }

    override public func fetchData<T: Decodable>(path: String, model: T.Type) async throws -> T {
        if let error = mockError {
            throw error
        }

        if let data = mockData {
            let decodedData = try JSONDecoder().decode(model, from: data)
            return decodedData
        }

        throw NSError(domain: "Mock Error", code: -1, userInfo: [NSLocalizedDescriptionKey: "Mock data or error not set."])
    }
}

class MockNetworkService: NetworkService {
    override init() {
        super.init()
        self.isConnected = true
    }
}
