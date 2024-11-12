//
//  RepositoryModel.swift
//  GitHubExplorer
//
//  Created by Afnan Alotaibi on 06/05/1446 AH.
//

import Foundation

struct RepositoryModel: Codable {
    let name: String
    let description: String?
    let license: License?
}

struct License: Codable {
    let name: String
}
