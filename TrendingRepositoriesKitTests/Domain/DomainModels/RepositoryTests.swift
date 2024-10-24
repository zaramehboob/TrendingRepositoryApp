//
//  RepositoryTests.swift
//  TrendingRepositoriesKitTests
//
//  Created by Zara on 10/06/2023.
//

import Foundation
import XCTest
@testable import TrendingRepositoriesKit

final class RepositoryTests: XCTestCase {
    
    func test_repository_attributes() {
        //given
        let owner = Owner(name: "elysae", avatarUrl: "https://avatars.githubusercontent.com/u/4314092?v=4")
        let description = "AI app with gpt"
        // when
        let sut = Repository(title: "awesome-gpt3", description: description, language: "swift", stars: 100, owner: owner)
        //then
        XCTAssertEqual(sut.title, "awesome-gpt3")
        XCTAssertEqual(sut.description, description)
        XCTAssertEqual(sut.language, "swift")
        XCTAssertEqual(sut.stars, 100)
        XCTAssertEqual(sut.owner, owner)
    
    }
}
