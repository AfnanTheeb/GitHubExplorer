//
//  UserModel.swift
//  GitHubExplorer
//
//  Created by Afnan Alotaibi on 06/05/1446 AH.
//

import Foundation

struct UserModel: Codable, Identifiable {
    let login: String
    let id: Int
    let avatarURL: String?
    var publicRepos: Int?
    var followers: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case login
        case avatarURL = "avatar_url"
        case publicRepos = "public_repos"
        case followers
    }
}

