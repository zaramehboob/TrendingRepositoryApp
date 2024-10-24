//
//  TrendingRepositoriesServiceType.swift
//  TrendingRepositoriesKit
//
//  Created by Zara on 12/06/2023.
//

import Foundation

protocol TrendingRepositoriesServiceType {
    func fetchRepositories(completion: @escaping (Result<[Repository], Error>) -> Void)
}
