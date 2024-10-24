//
//  NetworkError.swift
//  Networking
//
//  Created by Zara on 12/06/2023.
//

import Foundation

public enum NetworkError: LocalizedError {
    case error(statusCode: Int, data: Data?)
    case notConnected
    case notFound
    case decoding(Error)
}

extension NetworkError {
    public var errorDescription: String? {
        switch self {
            case .error(statusCode: let statusCode, data: let data):
                return "\(statusCode) \(String(data: data ?? Data(), encoding: .utf8) ?? "")"
            case .notConnected:
                return "Looks like you're offline"
            case .notFound:
                return "Resource Not Found"
            case .decoding(let error):
                return "\(error.localizedDescription)"
        }
    }
}
