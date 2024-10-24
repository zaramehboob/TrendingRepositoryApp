//
//  TrendingRepositoriesServiceTests.swift
//  TrendingRepositoriesKitTests
//
//  Created by Zara on 13/06/2023.
//

import Foundation
import XCTest
@testable import TrendingRepositoriesKit
import Networking

class MockNetworkService: NetworkServiceType {
    var fetchRespositoriesCompletionResult: Result<RepositoryResponseDTO, NetworkError>?
    var data: Data?
    
    func request<T>(with request: Networking.CustomRequestType, _ completion: @escaping (Result<T, NetworkError>) -> Void) {
        if let _ = fetchRespositoriesCompletionResult {
            guard let response = try? JSONDecoder().decode(RepositoryResponseDTO.self, from: data ?? Data()) else { completion(.failure(NetworkError.notFound) )
                return
            }
            
            completion(.success(response as! T))
        }
    }
}

class TrendingRepositoriesServiceTests: XCTestCase {
    
    func test_repositories_fetchedResponse_success() {
        let mockResponse = RepositoryResponseDTO.mock
        let service = MockNetworkService()
        service.fetchRespositoriesCompletionResult = .success( mockResponse )
        service.data = try! JSONEncoder().encode(mockResponse)
        let sut = TrendingRepositoriesService(service: service)
        let expectation = expectation(description: "fetch repositories from network service")
        
        sut.fetchRepositories { (result: Result<[Repository], Error>) -> Void in
            
            switch result {
                case .success(let repositories):
                    XCTAssertEqual(repositories.count, mockResponse.items.count)
                    XCTAssertEqual(repositories.first?.stars, mockResponse.items.first?.stargazersCount)
                case .failure(_):
                    XCTFail()
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_repositories_fetchedResponse_failure() {
        let service = MockNetworkService()
        service.fetchRespositoriesCompletionResult = .failure(NetworkError.notFound)
        let sut = TrendingRepositoriesService(service: service)
        let expectation = expectation(description: "fetch repositories from network service failed")
        
        sut.fetchRepositories { (result: Result<[Repository], Error>) -> Void in
            
            switch result {
                case .success(_):
                    XCTFail("dont expect success")
                case .failure(let error):
                    XCTAssertEqual(error.localizedDescription, NetworkError.notFound.errorDescription)
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
}
