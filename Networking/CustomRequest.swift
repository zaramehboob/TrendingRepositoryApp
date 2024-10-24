    //
    //  CustomRequest.swift
    //  Networking
    //
    //  Created by Zara on 13/06/2023.
    //

import Foundation

public protocol CustomRequestType {
    var url: String { get set }
    var httpMethod: String { get set }
    func simpleURLRequest() -> URLRequest?
}

public class CustomRequest: CustomRequestType {
    public var url: String
    public var httpMethod: String
    private let headers: [String: String] = ["Content-Type" : "application/json", "Accept": "application/json"]
    
    public init(url: String, httpMethod: String) {
        self.url = url
        self.httpMethod = httpMethod
    }
    
    public func simpleURLRequest() -> URLRequest? {
        guard let url = URL(string: url) else {return nil}
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethod
        
        for (key, value) in headers {
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }
        
        return urlRequest
    }
}
