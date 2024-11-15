//
//  APIService.swift
//  Afnan_Task_Gihub
//
//  Created by Afnan Alotaibi on 10/05/1446 AH.
//

import Foundation

public class APIService {
    private let baseURL = "https://api.github.com"
    
    private var accessToken: String? {
        return ProcessInfo.processInfo.environment["API_ACCESS_TOKEN"]
    }
    
    private func makeRequest(path: String) -> URLRequest? {
        guard let url = URL(string: "\(baseURL)\(path)") else {
            print("Error: Invalid URL with path \(path)")
            return nil
        }
        
        guard let token = accessToken else {
            print("Error: Access token not found in Environment Variables.")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("token \(token)", forHTTPHeaderField: "Authorization")
        
        print("Request URL: \(request.url?.absoluteString ?? "No URL")")
        print("Request Headers: \(request.allHTTPHeaderFields ?? [:])")
        
        return request
    }
    
    public func fetchData<T: Decodable>(path: String, model: T.Type) async throws -> T {
        guard let request = makeRequest(path: path) else {
            throw NSError(domain: "Invalid Request", code: -1, userInfo: nil)
        }
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let decodedData = try JSONDecoder().decode(model, from: data)
        return decodedData
    }
}
