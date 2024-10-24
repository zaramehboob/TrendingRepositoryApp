    //
    //  Client.swift
    //  Networking
    //
    //  Created by Zara on 13/06/2023.
    //

import Foundation

public protocol NetworkClientType {
    func fetch(with request: URLRequest, _ completion: @escaping ((data: Data?, error: NetworkError?)) -> Void)
}

public class HTTPClient: NetworkClientType {
    private var session = URLSession(configuration: URLSessionConfiguration.default)
    
    public init(){}
    
    public func fetch(with request: URLRequest, _ completion: @escaping ((data: Data?, error: NetworkError?)) -> Void) {
        let urlRequest = request
#if DEBUG
        
        urlRequest.allHTTPHeaderFields?.forEach { print("\($0.key) : \($0.value)") }
#endif
        
        let dataTask = session.dataTask(with: request) { data, response, error in
            
            guard error == nil else {
                let err = error as NSError?
                completion((nil, NetworkError.error(statusCode: err?.code ?? 0, data: data!)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion((nil, NetworkError.notFound))
                return
            }
            
            guard let jsonData = data else {
                completion((nil, NetworkError.error(statusCode: httpResponse.statusCode, data: nil)))
                return
            }
#if DEBUG
            let result = String(data: jsonData, encoding: .utf8)
            print(result!)
#endif
            completion((jsonData, nil))
            
        }
        dataTask.resume()
    }
}
