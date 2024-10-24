//
//  NetworkServiceTests.swift
//  NetworkingTests
//
//  Created by Zara on 12/06/2023.
//

import XCTest
import Foundation
@testable import Networking

class MockClient: NetworkClientType {
    var response: [String: String] = [:]
    private var mockData: Data? {
        return try? JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
    }
    
    func fetch(with request: URLRequest, _ completion: ((data: Data?, error: Networking.NetworkError?)) -> Void) {
        if let result = mockData {
            completion((result, nil))
        }
    }
}

final class NetworkServiceTests: XCTestCase {
    
    
    func test_fetch_withURLRequest_success() {
        let expectedResponseData = ["test": "NetworkService"]
        let request = CustomRequest(url: "http://google.com", httpMethod: "GET")
        let expectation = expectation(description: "data is parsed success")
        let client = MockClient()
        client.response = expectedResponseData
        let sut = NetworkService(client: client)
        sut.request(with: request) { (result: Result<[String: String], NetworkError>) in
            
            guard let responseData = try? result.get() else {
                XCTFail("Should return proper response")
                return
            }
            XCTAssertEqual(responseData, expectedResponseData)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
        
    }
}
