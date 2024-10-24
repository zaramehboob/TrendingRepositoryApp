    //
    //  NetworkService.swift
    //  Networking
    //
    //  Created by Zara on 12/06/2023.
    //

import Foundation

public protocol NetworkServiceType {
    func request<T: Decodable>(with request: CustomRequestType, _ completion: @escaping (Result<T, NetworkError>) -> Void)
}

public class NetworkService: NetworkServiceType {
    private let client: NetworkClientType
    public init(client: NetworkClientType) {
        self.client = client
    }
    
    private var session = URLSession(configuration: URLSessionConfiguration.default)
    
    public func request<T: Decodable>(with request: CustomRequestType, _ completion: @escaping (Result<T, NetworkError>) -> Void) {
        
        guard let urlRequest = request.simpleURLRequest() else { completion(.failure(NetworkError.notFound))
            return
        }
        
        client.fetch(with: urlRequest) { (data: Data?, error: NetworkError?) in
            
            guard error == nil else {
                completion(.failure(error ?? NetworkError.notFound))
                return
            }
            
            guard let jsonData = data else {
                completion(.failure(.notFound))
                return
            }
            
            do {
                let object: T = try JSONDecoder().decode(T.self, from: jsonData)
                completion(.success(object))
            } catch {
                completion(.failure(.decoding(error)))
            }
        }
    }
}
