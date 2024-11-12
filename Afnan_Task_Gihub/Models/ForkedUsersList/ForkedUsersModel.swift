//
//  ForkedUsersModel.swift
//  GitHubExplorer
//
//  Created by Afnan Alotaibi on 08/05/1446 AH.
//

import Foundation

struct ForkedUserModel: Identifiable, Decodable {
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

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let ownerContainer = try container.nestedContainer(keyedBy: OwnerKeys.self, forKey: .owner)

        self.id = try container.decode(Int.self, forKey: .id)
        self.login = try ownerContainer.decode(String.self, forKey: .login)
        
        self.avatarUrl = try ownerContainer.decodeIfPresent(String.self, forKey: .avatarUrl)
    }
}
