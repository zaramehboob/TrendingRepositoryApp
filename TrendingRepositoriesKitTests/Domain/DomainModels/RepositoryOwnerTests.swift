//
//  RepositoryOwnerTests.swift
//  TrendingRepositoriesKitTests
//
//  Created by Zara on 10/06/2023.
//

import Foundation
import XCTest
@testable import TrendingRepositoriesKit

final class RepositoryOwnerTests: XCTestCase {
    
    func test_repositoryOwner_attributes() {
        
        let mockAttributes = ["name": "elysae", "avatarURL": "https://avatars.githubusercontent.com/u/4314092?v=4"]
        let sut = Owner(name: mockAttributes["name"] ?? "", avatarUrl: mockAttributes["avatarURL"] ?? "")
        
        XCTAssertEqual(sut.name , mockAttributes["name"])
        XCTAssertEqual(sut.avatarUrl, mockAttributes["avatarURL"])
        
    }

}
