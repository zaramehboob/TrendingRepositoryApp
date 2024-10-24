//
//  TrendingRepositoryListViewModelTests.swift
//  TrendingRepositoriesKitTests
//
//  Created by Zara on 10/06/2023.
//

import Foundation
import XCTest
@testable import TrendingRepositoriesKit


final private class MockFetchUseCase: FetchUseCaseType {
    var fetchRespositoriesCompletionResult: Result<[TrendingRepositoriesKit.Repository], Error>?
    var expectation: XCTestExpectation?
    func fetch(completion: @escaping (Result<[TrendingRepositoriesKit.Repository], Error>) -> Void) {
        if let result = fetchRespositoriesCompletionResult {
            completion(result)
            expectation?.fulfill()
        }
    }
    
}

final class TrendingRepositoryListViewModelTests: XCTestCase {

    private let mockRepositories = [Repository(title: "awesome-gpt3", description: "AI app using gpt", language: "swift", stars: 100, owner: Owner(name: "elysae", avatarUrl: "https://avatars.githubusercontent.com/u/4314092?v=4")), Repository(title: "awesome-gpt3", description: "AI app using gpt", language: "swift", stars: 10, owner: Owner(name: "test", avatarUrl: "https://avatars.githubusercontent.com/u/4314092?v=4"))]
    
    func test_repositoriesCount_whenFetched_success() {
        //given
        let sut = makeSUT(with: .success(mockRepositories), expectation: expectation(description: "Count after fetching"))
        //when
        sut.onViewLoad()
        
        //then
        waitForExpectations(timeout: 2, handler: nil)
        XCTAssertEqual(sut.repositoryListCount, mockRepositories.count)
        
    }
    
    func test_repositoriesCount_whenFetched_failure() {
        let sut = makeSUT(with: .failure(FetchUseCaseError.someError), expectation: expectation(description: "Count after fetching failed"))
        sut.repositoryListCount = 3
        
        //when
        sut.onViewLoad()
        
        //then
        waitForExpectations(timeout: 3, handler: nil)
        XCTAssertEqual(sut.repositoryListCount, 0)
    }
    
    func test_errorString_whenFetched_failure() {
        let sut = makeSUT(with: .failure(FetchUseCaseError.someError), expectation: expectation(description: "Error is send"))
      
        sut.repositoryListCount = 3
        
        let _ = sut.error.sink(receiveValue: { value in
            XCTAssertEqual(value, FetchUseCaseError.someError.localizedDescription)
        })
        
            //when
        sut.onViewLoad()
        
            //then
        waitForExpectations(timeout: 2, handler: nil)
        
    }
    
    func test_repositoryCellViewModel_ForIndexPath() {
        //given
        let sut = makeSUT(with: .success(mockRepositories), expectation: expectation(description: "Repositories are created"))
        let indexPath = IndexPath(row: 0, section: 0)
        //when
        sut.onViewLoad()
        
        let viewModel = sut.getRepositoryViewModel(for: indexPath.row) as! RepositoryCellViewModel
        
        waitForExpectations(timeout: 3, handler: nil)
        XCTAssertTrue(sut.repositoryListCount > indexPath.row)
        XCTAssertFalse(viewModel === createCellViewModels()[indexPath.row])
        XCTAssert(viewModel == createCellViewModels()[indexPath.row])

    }
    
    func test_retry_success() {
        //given
        let sut = makeSUT(with: .success(mockRepositories), expectation: expectation(description: "Count after refreshing list"))
        
        //when
        sut.retry()
        
        //then
        waitForExpectations(timeout: 2, handler: nil)
        XCTAssertEqual(sut.repositoryListCount, mockRepositories.count)
    }
}

private extension TrendingRepositoryListViewModelTests {
    
    func makeSUT(with mockResult: Result<[TrendingRepositoriesKit.Repository], Error>? = nil, expectation: XCTestExpectation? = nil) -> TrendingRepositoryListViewModel {
        
        let fetchUseCase = MockFetchUseCase()
        fetchUseCase.fetchRespositoriesCompletionResult = mockResult
        fetchUseCase.expectation = expectation
        
        let sut = TrendingRepositoryListViewModel(fetchUseCase: fetchUseCase)
        
        return sut
    }
    
    func createCellViewModels() -> [RepositoryCellViewModel] {
        return mockRepositories.map { RepositoryCellViewModel(repository: $0) }
    }
}
