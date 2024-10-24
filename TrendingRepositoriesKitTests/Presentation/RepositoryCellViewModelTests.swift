//
//  RepositoryCellViewModelTests.swift
//  TrendingRepositoriesKitTests
//
//  Created by Zara on 11/06/2023.
//

import Foundation
import XCTest
@testable import TrendingRepositoriesKit

final class RepositoryCellViewModelTests: XCTestCase {
    
    private let mockRepository = Repository(title: "awesome-gpt3", description: "AI app using gpt", language: "swift", stars: 100, owner: Owner(name: "elysae", avatarUrl: "https://avatars.githubusercontent.com/u/4314092?v=4"))
                                  
    func test_repository_attributes() {
        //when
        let sut = RepositoryCellViewModel(repository: mockRepository)
        //then
        let _ = sut.attributes.sink(receiveValue: { value in
            XCTAssertEqual(value.title, self.mockRepository.title)
            XCTAssertEqual(value.language, self.mockRepository.language)
            XCTAssertEqual(value.stars, self.mockRepository.stars)
        })
    }
    
    func test_repository_owner() {
        //when
        let sut = RepositoryCellViewModel(repository: mockRepository)
        
        //then
        let _ = sut.owner.sink(receiveValue: { owner in
            XCTAssertEqual(owner.name, self.mockRepository.owner.name)
            XCTAssertEqual(owner.url, self.mockRepository.owner.avatarUrl)
            
        })
    }
    
    func test_shimmerValue_whenLoading_true() {
        //when
        let sut = RepositoryCellViewModel(repository: mockRepository, isShimmerOn: true)
        
        //then
        let _ = sut.shimmer.sink(receiveValue: { isOn in
            XCTAssertTrue(isOn)
        })
    }
}
