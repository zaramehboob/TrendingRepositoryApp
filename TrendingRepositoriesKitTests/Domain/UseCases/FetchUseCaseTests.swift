//
//  FetchUseCaseTests.swift
//  TrendingRepositoriesKitTests
//
//  Created by Zara on 12/06/2023.
//

import Foundation
import XCTest
@testable import TrendingRepositoriesKit

private class MockService: TrendingRepositoriesServiceType {
    var completionResult: Result<[Repository], Error>?
    func fetchRepositories(completion: @escaping (Result<[Repository], Error>) -> Void) {
        if let result = completionResult {
            completion(result)
        }
    }
}

final class FetchUseCaseTests: XCTestCase {
    
    private let mockRepositories = [Repository(title: "awesome-gpt3", description: "AI app using gpt", language: "swift", stars: 100, owner: Owner(name: "elysae", avatarUrl: "https://avatars.githubusercontent.com/u/4314092?v=4")), Repository(title: "awesome-gpt3", description: "swift app using gpt", language: "swift", stars: 500, owner: Owner(name: "test", avatarUrl: "https://avatars.githubusercontent.com/u/4314092?v=4"))]
    
    func test_fetch_repositories_success() {
        //given
        let service = MockService()
        service.completionResult = .success(mockRepositories)
        let sut = FetchUseCase(service: service)
        let expectation = expectation(description: "fetch repositories from servie")
        
        
        //when
        sut.fetch { result in
            switch result {
                case .failure(_):
                    XCTFail("Result has to be success")
                case .success(let response):
                    XCTAssertEqual(response.first!.title, self.mockRepositories.first!.title)
                    XCTAssertEqual(response.last!.title, self.mockRepositories.last!.title)
                    
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2.0)
    }
    
    func test_fetch_repositories_failure() {
        
        let service = MockService()
        service.completionResult = .failure(FetchUseCaseError.someError)
        let sut = FetchUseCase(service: service)
        let expectation = expectation(description: "fetch repositories from servie")
        
        
            //when
        sut.fetch { result in
            switch result {
                case .failure(let error):
                    XCTAssertNotNil(error)
                case .success(_):
                    XCTFail("Result has to be error")
                    
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2.0)
    }
}
