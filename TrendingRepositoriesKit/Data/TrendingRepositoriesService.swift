    //
    //  TrendingRepositoriesService.swift
    //  TrendingRepositoriesKit
    //
    //  Created by Zara on 12/06/2023.
    //

import Networking

class TrendingRepositoriesService: TrendingRepositoriesServiceType {
    
    private let service: NetworkServiceType
    init(service: NetworkServiceType) {
        self.service = service
    }
    
    func fetchRepositories(completion: @escaping (Result<[Repository], Error>) -> Void) {
        let request = CustomRequest(url: "https://api.github.com/search/repositories?q=language=+sort:stars", httpMethod: "GET")
        service.request(with: request) { (result: Result<RepositoryResponseDTO, NetworkError>) in
            switch result {
                case .success(let response):
                    completion(.success(response.toDomain().list))
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }
}
