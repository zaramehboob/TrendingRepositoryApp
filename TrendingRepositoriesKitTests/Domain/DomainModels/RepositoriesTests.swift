//
//  RepositoriesTests.swift
//  TrendingRepositoriesKitTests
//
//  Created by Zara on 10/06/2023.
//

import Foundation

import XCTest
@testable import TrendingRepositoriesKit

final class RepositoriesTests: XCTestCase {
    
    func test_repositories() {
        //given
        let owner = Owner(name: "elysae", avatarUrl: "https://avatars.githubusercontent.com/u/4314092?v=4")
        let mockList = [Repository(title: "awesome-gpt3", description: "AI app using gpt", language: "swift", stars: 100, owner: owner)]
        //when
        let sut = Repositories(list: mockList)
        
        //then
        XCTAssertEqual(sut.list.count, 1)
        XCTAssertEqual(sut.list.first!.title, "awesome-gpt3")
    }
    
}
