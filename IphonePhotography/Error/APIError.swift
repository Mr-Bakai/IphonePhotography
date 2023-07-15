//
//  APIError.swift
//  IphonePhotography
//
//  Created by Bakai on 15/7/23.
//

import Foundation

enum APIError: Error {
    case decodingError
    case errorCode(Int)
    case unknown
}

extension APIError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .decodingError:
            return "Failed to decode the object from the service"
            
        case .errorCode(let statusCode):
            return "\(statusCode) - Something went wrong"
            
        case .unknown:
            return "The error is unkown"
        }
    }
}
