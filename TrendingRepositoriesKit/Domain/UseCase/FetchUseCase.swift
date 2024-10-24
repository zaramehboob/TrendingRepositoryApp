//
//  FetchUseCase.swift
//  TrendingRepositoriesKit
//
//  Created by Zara on 10/06/2023.
//

import Foundation

protocol FetchUseCaseType {
    func fetch(completion: @escaping (Result<[Repository], Error>) -> Void)
}

class FetchUseCase: FetchUseCaseType {
    
    private let service: TrendingRepositoriesServiceType
    init(service: TrendingRepositoriesServiceType) {
        self.service = service
    }
    
    func fetch(completion: @escaping (Result<[Repository], Error>) -> Void) {
        service.fetchRepositories { (result: Result<[Repository], Error>) -> Void in
            completion(result)
        }
    }
}
