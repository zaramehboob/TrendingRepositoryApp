//
//  Repository.swift
//  TrendingRepositoriesKit
//
//  Created by Zara on 10/06/2023.
//

import Foundation

struct Repository {
 
    let title: String
    let description: String
    let language: String
    let stars: Int
    let owner: Owner
}

extension Repository {
    static let dummy = Repository(title: "dummy title", description: "dummy text", language: "swift", stars: 300, owner: Owner(name: "dummy name", avatarUrl: ""))
}
