//
//  ForkedUsersModel.swift
//  GitHubExplorer
//
//  Created by Afnan Alotaibi on 08/05/1446 AH.
//

import Foundation

struct ForkedUserModel: Identifiable, Codable {
    let id: Int
    let login: String
    let avatarUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case owner
    }
    
    enum OwnerKeys: String, CodingKey {
        case login
        case avatarUrl = "avatar_url"
    }
    
    init(id: Int, login: String, avatarUrl: String?) {
        self.id = id
        self.login = login
        self.avatarUrl = avatarUrl
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let ownerContainer = try container.nestedContainer(keyedBy: OwnerKeys.self, forKey: .owner)
        
        self.id = try container.decode(Int.self, forKey: .id)
        self.login = try ownerContainer.decode(String.self, forKey: .login)
        
        self.avatarUrl = try ownerContainer.decodeIfPresent(String.self, forKey: .avatarUrl)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        var ownerContainer = container.nestedContainer(keyedBy: OwnerKeys.self, forKey: .owner)
        
        try container.encode(id, forKey: .id)
        try ownerContainer.encode(login, forKey: .login)
        try ownerContainer.encode(avatarUrl, forKey: .avatarUrl)
    }
}
